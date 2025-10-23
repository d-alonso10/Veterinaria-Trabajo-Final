package control;

import dao.PagoDao;
import dao.FacturaDao;
import modelo.Pago;
import modelo.Factura;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/PagoControlador"})
public class PagoControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");

        try {
            if (accion != null) {
                switch (accion) {
                    case "registrar":
                        registrarPago(request, response);
                        break;
                    case "listarPorFactura":
                        listarPagosPorFactura(request, response);
                        break;
                    case "buscarPagos":
                        buscarPagos(request, response);
                        break;
                    case "anularPago":
                        anularPago(request, response);
                        break;
                    case "listarTodos":
                        listarTodosPagos(request, response);
                        break;
                    case "pagosPorFecha":
                        listarPagosPorFecha(request, response);
                        break;
                    case "confirmarPago":
                        confirmarPago(request, response);
                        break;
                    default:
                        response.sendRedirect("UtilidadesPagos.jsp");
                }
            } else {
                response.sendRedirect("UtilidadesPagos.jsp");
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error general en el controlador de pagos");
        }
    }

    private void registrarPago(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idFacturaStr = limpiarParametro(request.getParameter("idFactura"));
            String montoStr = limpiarParametro(request.getParameter("monto"));
            String metodo = limpiarParametro(request.getParameter("metodo"));
            String referencia = limpiarParametro(request.getParameter("referencia"));

            if (idFacturaStr.isEmpty() || montoStr.isEmpty() || metodo.isEmpty()) {
                request.setAttribute("mensaje", "❌ Factura, monto y método de pago son obligatorios");
                request.getRequestDispatcher("RegistrarPago.jsp").forward(request, response);
                return;
            }

            int idFactura;
            double monto;

            try {
                idFactura = Integer.parseInt(idFacturaStr);
                if (idFactura <= 0) {
                    throw new NumberFormatException("ID debe ser positivo");
                }

                monto = Double.parseDouble(montoStr);
                if (monto <= 0) {
                    throw new NumberFormatException("Monto debe ser positivo");
                }

                if (monto > 50000.00) {
                    request.setAttribute("mensaje", "❌ El monto no puede exceder $50,000.00");
                    request.getRequestDispatcher("RegistrarPago.jsp").forward(request, response);
                    return;
                }

            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ ID de factura o monto inválidos");
                request.getRequestDispatcher("RegistrarPago.jsp").forward(request, response);
                return;
            }

            // CORRECCIÓN: Métodos de pago según el DAO (en minúsculas)
            String[] metodosPermitidos = {"efectivo", "tarjeta_credito", "tarjeta_debito", "transferencia", "cheque", "paypal", "yape", "plin"};
            boolean metodoValido = false;
            for (String metodoPermitido : metodosPermitidos) {
                if (metodoPermitido.equals(metodo.toLowerCase())) {
                    metodo = metodoPermitido;
                    metodoValido = true;
                    break;
                }
            }

            if (!metodoValido) {
                request.setAttribute("mensaje", "❌ Método de pago no válido");
                request.getRequestDispatcher("RegistrarPago.jsp").forward(request, response);
                return;
            }

            if (("transferencia".equals(metodo) || "cheque".equals(metodo)) && referencia.isEmpty()) {
                request.setAttribute("mensaje", "❌ Referencia es obligatoria para " + metodo);
                request.getRequestDispatcher("RegistrarPago.jsp").forward(request, response);
                return;
            }

            // CORRECCIÓN: Verificar que la factura existe
            FacturaDao facturaDao = new FacturaDao();
            Factura factura = facturaDao.obtenerFacturaPorId(idFactura);
            if (factura == null) {
                request.setAttribute("mensaje", "❌ Factura no encontrada");
                request.getRequestDispatcher("RegistrarPago.jsp").forward(request, response);
                return;
            }

            // CORRECCIÓN: Estados según el DAO
            if ("anulada".equals(factura.getEstado()) || "pagada".equals(factura.getEstado())) {
                request.setAttribute("mensaje", "❌ No se pueden registrar pagos para facturas " + factura.getEstado().toLowerCase());
                request.getRequestDispatcher("RegistrarPago.jsp").forward(request, response);
                return;
            }

            // Verificar que el monto no exceda el saldo pendiente
            PagoDao pagoDao = new PagoDao();
            double totalPagado = pagoDao.obtenerTotalPagadoFactura(idFactura);
            double saldoPendiente = factura.getTotal() - totalPagado;

            if (monto > saldoPendiente) {
                request.setAttribute("mensaje", String.format("❌ El monto ($%.2f) excede el saldo pendiente ($%.2f)", 
                    monto, saldoPendiente));
                request.getRequestDispatcher("RegistrarPago.jsp").forward(request, response);
                return;
            }

            Pago pago = new Pago();
            pago.setIdFactura(idFactura);
            pago.setMonto(monto);
            pago.setMetodo(metodo);
            pago.setReferencia(referencia.isEmpty() ? null : referencia);

            boolean exito = pagoDao.registrarPago(pago);

            if (exito) {
                double nuevoSaldo = saldoPendiente - monto;
                request.setAttribute("mensaje", String.format("✅ Pago registrado exitosamente por $%.2f. Saldo restante: $%.2f", 
                    monto, nuevoSaldo));
                request.setAttribute("tipoMensaje", "success");
                
                request.removeAttribute("idFactura");
                request.removeAttribute("monto");
                request.removeAttribute("metodo");
                request.removeAttribute("referencia");
            } else {
                request.setAttribute("mensaje", "❌ Error al registrar el pago");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al registrar pago");
            return;
        }

        request.getRequestDispatcher("RegistrarPago.jsp").forward(request, response);
    }

    private void listarPagosPorFactura(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idFacturaStr = limpiarParametro(request.getParameter("idFactura"));

            if (idFacturaStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de factura requerido");
                request.getRequestDispatcher("BuscarPagos.jsp").forward(request, response);
                return;
            }

            int idFactura = Integer.parseInt(idFacturaStr);

            PagoDao dao = new PagoDao();
            List<Pago> pagos = dao.obtenerPagosPorFactura(idFactura);

            if (pagos != null && !pagos.isEmpty()) {
                request.setAttribute("pagos", pagos);
                request.setAttribute("totalPagos", pagos.size());
                request.setAttribute("idFacturaConsulta", idFactura);

                double totalPagado = 0.0;
                for (Pago pago : pagos) {
                    // CORRECCIÓN: Estado según DAO
                    if (!"fallido".equals(pago.getEstado())) {
                        totalPagado += pago.getMonto();
                    }
                }
                request.setAttribute("totalPagado", totalPagado);

                FacturaDao facturaDao = new FacturaDao();
                Factura factura = facturaDao.obtenerFacturaPorId(idFactura);
                if (factura != null) {
                    request.setAttribute("totalFactura", factura.getTotal());
                    request.setAttribute("saldoPendiente", factura.getTotal() - totalPagado);
                    request.setAttribute("serieNumeroFactura", factura.getSerie() + "-" + factura.getNumero());
                }

                request.setAttribute("mensaje", "✅ Se encontraron " + pagos.size() + " pagos");
            } else {
                request.setAttribute("pagos", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron pagos para esta factura");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de factura inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar pagos por factura");
            return;
        }

        request.getRequestDispatcher("PagosPorFactura.jsp").forward(request, response);
    }

    private void buscarPagos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String metodo = limpiarParametro(request.getParameter("metodo"));
            String estado = limpiarParametro(request.getParameter("estado"));
            String referencia = limpiarParametro(request.getParameter("referencia"));
            String montoMinStr = limpiarParametro(request.getParameter("montoMin"));
            String montoMaxStr = limpiarParametro(request.getParameter("montoMax"));

            PagoDao dao = new PagoDao();
            List<Pago> pagos = null;

            Double montoMin = null, montoMax = null;
            if (!montoMinStr.isEmpty()) {
                try {
                    montoMin = Double.parseDouble(montoMinStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "⚠️ Monto mínimo inválido, ignorando criterio");
                }
            }

            if (!montoMaxStr.isEmpty()) {
                try {
                    montoMax = Double.parseDouble(montoMaxStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "⚠️ Monto máximo inválido, ignorando criterio");
                }
            }

            if (montoMin != null && montoMax != null && montoMin > montoMax) {
                request.setAttribute("mensaje", "❌ El monto mínimo no puede ser mayor que el máximo");
                request.getRequestDispatcher("BuscarPagos.jsp").forward(request, response);
                return;
            }

            // CORRECCIÓN: Usar el método correcto del DAO
            pagos = dao.buscarPagos(metodo, estado, referencia, montoMin, montoMax);

            if (pagos != null && !pagos.isEmpty()) {
                request.setAttribute("pagos", pagos);
                request.setAttribute("totalPagos", pagos.size());

                double totalEncontrado = 0.0;
                int pagosPendientes = 0, pagosConfirmados = 0, pagosAnulados = 0;

                for (Pago pago : pagos) {
                    // CORRECCIÓN: Estados según DAO
                    if (!"fallido".equals(pago.getEstado())) {
                        totalEncontrado += pago.getMonto();
                    }
                    
                    switch (pago.getEstado()) {
                        case "pendiente":
                            pagosPendientes++;
                            break;
                        case "confirmado":
                            pagosConfirmados++;
                            break;
                        case "fallido":
                            pagosAnulados++;
                            break;
                    }
                }

                request.setAttribute("totalEncontrado", totalEncontrado);
                request.setAttribute("pagosPendientes", pagosPendientes);
                request.setAttribute("pagosConfirmados", pagosConfirmados);
                request.setAttribute("pagosAnulados", pagosAnulados);
                request.setAttribute("mensaje", "✅ Se encontraron " + pagos.size() + " pagos");
            } else {
                request.setAttribute("pagos", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron pagos con los criterios especificados");
            }

            request.setAttribute("metodoBusqueda", metodo);
            request.setAttribute("estadoBusqueda", estado);
            request.setAttribute("referenciaBusqueda", referencia);
            request.setAttribute("montoMinBusqueda", montoMinStr);
            request.setAttribute("montoMaxBusqueda", montoMaxStr);

        } catch (Exception e) {
            manejarError(request, response, e, "Error al buscar pagos");
            return;
        }

        request.getRequestDispatcher("BuscarPagos.jsp").forward(request, response);
    }

    private void anularPago(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idPagoStr = limpiarParametro(request.getParameter("idPago"));
            String motivo = limpiarParametro(request.getParameter("motivo"));

            if (idPagoStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de pago requerido");
                request.getRequestDispatcher("BuscarPagos.jsp").forward(request, response);
                return;
            }

            if (motivo.isEmpty()) {
                request.setAttribute("mensaje", "❌ Motivo de anulación es obligatorio");
                request.getRequestDispatcher("DetallePago.jsp").forward(request, response);
                return;
            }

            int idPago = Integer.parseInt(idPagoStr);

            PagoDao dao = new PagoDao();
            boolean exito = dao.anularPago(idPago, motivo);

            if (exito) {
                request.setAttribute("mensaje", "✅ Pago anulado exitosamente");
                request.setAttribute("tipoMensaje", "success");
            } else {
                request.setAttribute("mensaje", "❌ Error al anular el pago");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de pago inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al anular pago");
            return;
        }

        request.getRequestDispatcher("DetallePago.jsp").forward(request, response);
    }

    private void confirmarPago(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idPagoStr = limpiarParametro(request.getParameter("idPago"));

            if (idPagoStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de pago requerido");
                request.getRequestDispatcher("BuscarPagos.jsp").forward(request, response);
                return;
            }

            int idPago = Integer.parseInt(idPagoStr);

            PagoDao dao = new PagoDao();
            boolean exito = dao.confirmarPago(idPago);

            if (exito) {
                request.setAttribute("mensaje", "✅ Pago confirmado exitosamente");
                request.setAttribute("tipoMensaje", "success");
            } else {
                request.setAttribute("mensaje", "❌ Error al confirmar el pago");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de pago inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al confirmar pago");
            return;
        }

        request.getRequestDispatcher("DetallePago.jsp").forward(request, response);
    }

    private void listarPagosPorFecha(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String fechaInicioStr = limpiarParametro(request.getParameter("fechaInicio"));
            String fechaFinStr = limpiarParametro(request.getParameter("fechaFin"));

            if (fechaInicioStr.isEmpty() || fechaFinStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Fechas de inicio y fin son obligatorias");
                request.getRequestDispatcher("PagosPorFecha.jsp").forward(request, response);
                return;
            }

            // CORRECCIÓN: Usar java.sql.Date en lugar de Timestamp
            Date fechaInicio = Date.valueOf(fechaInicioStr);
            Date fechaFin = Date.valueOf(fechaFinStr);

            if (fechaInicio.after(fechaFin)) {
                request.setAttribute("mensaje", "❌ La fecha de inicio no puede ser mayor que la fecha fin");
                request.getRequestDispatcher("PagosPorFecha.jsp").forward(request, response);
                return;
            }

            PagoDao dao = new PagoDao();
            // CORRECCIÓN: Usar el método correcto que retorna List<Pago>
            List<Pago> pagos = dao.obtenerPagosPorFecha(fechaInicio, fechaFin);

            if (pagos != null && !pagos.isEmpty()) {
                request.setAttribute("pagos", pagos);
                request.setAttribute("totalPagos", pagos.size());
                request.setAttribute("fechaInicio", fechaInicioStr);
                request.setAttribute("fechaFin", fechaFinStr);

                double totalEfectivo = 0.0, totalTarjeta = 0.0, totalTransferencia = 0.0, totalOtros = 0.0;
                
                for (Pago pago : pagos) {
                    // CORRECCIÓN: Estado según DAO
                    if (!"fallido".equals(pago.getEstado())) {
                        switch (pago.getMetodo()) {
                            case "efectivo":
                                totalEfectivo += pago.getMonto();
                                break;
                            case "tarjeta_credito":
                            case "tarjeta_debito":
                                totalTarjeta += pago.getMonto();
                                break;
                            case "transferencia":
                                totalTransferencia += pago.getMonto();
                                break;
                            default:
                                totalOtros += pago.getMonto();
                        }
                    }
                }

                request.setAttribute("totalEfectivo", totalEfectivo);
                request.setAttribute("totalTarjeta", totalTarjeta);
                request.setAttribute("totalTransferencia", totalTransferencia);
                request.setAttribute("totalOtros", totalOtros);
                request.setAttribute("totalGeneral", totalEfectivo + totalTarjeta + totalTransferencia + totalOtros);
                request.setAttribute("mensaje", "✅ Se encontraron " + pagos.size() + " pagos en el período");
            } else {
                request.setAttribute("pagos", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron pagos en el período especificado");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar pagos por fecha");
            return;
        }

        request.getRequestDispatcher("PagosPorFecha.jsp").forward(request, response);
    }

    private void listarTodosPagos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String limiteStr = limpiarParametro(request.getParameter("limite"));
            Integer limite = 100;

            if (!limiteStr.isEmpty()) {
                try {
                    int limiteParsed = Integer.parseInt(limiteStr);
                    if (limiteParsed > 0 && limiteParsed <= 1000) {
                        limite = limiteParsed;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "⚠️ Límite inválido, usando valor por defecto (100)");
                }
            }

            PagoDao dao = new PagoDao();
            // CORRECCIÓN: Usar el método correcto que retorna List<Pago>
            List<Pago> pagos = dao.listarTodosPagos(limite);

            if (pagos != null && !pagos.isEmpty()) {
                request.setAttribute("pagos", pagos);
                request.setAttribute("totalPagos", pagos.size());
                request.setAttribute("limiteAplicado", limite);

                double totalPagos = 0.0;
                for (Pago pago : pagos) {
                    // CORRECCIÓN: Estado según DAO
                    if (!"fallido".equals(pago.getEstado())) {
                        totalPagos += pago.getMonto();
                    }
                }
                request.setAttribute("totalPagos", totalPagos);
                request.setAttribute("mensaje", "✅ Últimos " + pagos.size() + " pagos del sistema");
            } else {
                request.setAttribute("pagos", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron pagos en el sistema");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar todos los pagos");
            return;
        }

        request.getRequestDispatcher("ListaPagos.jsp").forward(request, response);
    }

    private void manejarError(HttpServletRequest request, HttpServletResponse response, 
                             Exception e, String mensajeContexto) 
            throws ServletException, IOException {
        
        System.err.println("=== ERROR EN PAGO CONTROLADOR ===");
        System.err.println("Contexto: " + mensajeContexto);
        System.err.println("Mensaje: " + e.getMessage());
        e.printStackTrace();

        request.setAttribute("mensaje", "❌ " + mensajeContexto + ": " + e.getMessage());
        request.setAttribute("tipoMensaje", "error");
        
        request.getRequestDispatcher("UtilidadesPagos.jsp").forward(request, response);
    }

    private String limpiarParametro(String param) {
        if (param == null) {
            return "";
        }
        return param.trim();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Controlador para gestión completa de pagos";
    }
}