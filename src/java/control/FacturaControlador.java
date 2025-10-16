package control;

import dao.FacturaDao;
import dao.ClienteDao;
import modelo.Factura;
import modelo.FacturaClienteDTO;
import modelo.Cliente;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/FacturaControlador"})
public class FacturaControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");

        try {
            if (accion != null) {
                switch (accion) {
                    case "crear":
                        crearFactura(request, response);
                        break;
                    case "listarPorCliente":
                        listarFacturasPorCliente(request, response);
                        break;
                    case "buscarFacturas":
                        buscarFacturas(request, response);
                        break;
                    case "obtenerDetalle":
                        obtenerDetalleFactura(request, response);
                        break;
                    case "anular":
                        anularFactura(request, response);
                        break;
                    case "listarTodas":
                        listarTodasFacturas(request, response);
                        break;
                    default:
                        response.sendRedirect("UtilidadesFacturas.jsp");
                }
            } else {
                response.sendRedirect("UtilidadesFacturas.jsp");
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error general en el controlador de facturas");
        }
    }

    /**
     * Crea una nueva factura basada en una atención
     */
    private void crearFactura(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener parámetros
            String serieStr = limpiarParametro(request.getParameter("serie"));
            String numeroStr = limpiarParametro(request.getParameter("numero"));
            String idAtencionStr = limpiarParametro(request.getParameter("idAtencion"));
            String metodoPago = limpiarParametro(request.getParameter("metodoPago"));

            // Validaciones básicas
            if (serieStr.isEmpty() || numeroStr.isEmpty() || idAtencionStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Serie, número y atención son obligatorios");
                request.getRequestDispatcher("CrearFactura.jsp").forward(request, response);
                return;
            }

            // Validar formato de serie y número
            if (!serieStr.matches("[A-Z]{1,4}")) {
                request.setAttribute("mensaje", "❌ Serie debe contener solo letras mayúsculas (1-4 caracteres)");
                request.getRequestDispatcher("CrearFactura.jsp").forward(request, response);
                return;
            }

            if (!numeroStr.matches("\\d{1,8}")) {
                request.setAttribute("mensaje", "❌ Número debe contener solo dígitos (1-8 caracteres)");
                request.getRequestDispatcher("CrearFactura.jsp").forward(request, response);
                return;
            }

            // Convertir ID de atención
            int idAtencion;
            try {
                idAtencion = Integer.parseInt(idAtencionStr);
                if (idAtencion <= 0) {
                    throw new NumberFormatException("ID debe ser positivo");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ ID de atención inválido");
                request.getRequestDispatcher("CrearFactura.jsp").forward(request, response);
                return;
            }

            // Validar método de pago
            if (metodoPago.isEmpty()) {
                metodoPago = "EFECTIVO"; // Valor por defecto
            } else {
                String[] metodosValidos = {"EFECTIVO", "TARJETA_CREDITO", "TARJETA_DEBITO", "TRANSFERENCIA", "CHEQUE"};
                boolean metodovalido = false;
                for (String metodo : metodosValidos) {
                    if (metodo.equals(metodoPago.toUpperCase())) {
                        metodoPago = metodo;
                        metodovalido = true;
                        break;
                    }
                }
                if (!metodovalido) {
                    request.setAttribute("mensaje", "❌ Método de pago no válido");
                    request.getRequestDispatcher("CrearFactura.jsp").forward(request, response);
                    return;
                }
            }

            // Crear objeto Factura
            Factura factura = new Factura();
            factura.setSerie(serieStr.toUpperCase());
            factura.setNumero(numeroStr);
            factura.setIdAtencion(idAtencion);
            factura.setMetodoPagoSugerido(metodoPago);

            // Crear factura en la base de datos
            FacturaDao dao = new FacturaDao();
            boolean exito = dao.crearFactura(factura);

            if (exito) {
                request.setAttribute("mensaje", "✅ Factura creada exitosamente: " + serieStr + "-" + numeroStr);
                request.setAttribute("tipoMensaje", "success");
                
                // Limpiar formulario
                request.removeAttribute("serie");
                request.removeAttribute("numero");
                request.removeAttribute("idAtencion");
                request.removeAttribute("metodoPago");
            } else {
                request.setAttribute("mensaje", "❌ Error al crear la factura. Verifique que la serie y número no estén duplicados");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al crear la factura");
            return;
        }

        request.getRequestDispatcher("CrearFactura.jsp").forward(request, response);
    }

    /**
     * Lista facturas por cliente específico
     */
    private void listarFacturasPorCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idClienteStr = limpiarParametro(request.getParameter("idCliente"));

            if (idClienteStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de cliente requerido");
                request.getRequestDispatcher("BuscarFacturas.jsp").forward(request, response);
                return;
            }

            int idCliente = Integer.parseInt(idClienteStr);

            FacturaDao dao = new FacturaDao();
            List<Factura> facturas = dao.obtenerFacturasPorCliente(idCliente);

            if (facturas != null && !facturas.isEmpty()) {
                request.setAttribute("facturas", facturas);
                request.setAttribute("totalFacturas", facturas.size());
                request.setAttribute("idClienteConsulta", idCliente);

                // Calcular totales
                double totalFacturado = 0.0;
                for (Factura factura : facturas) {
                    totalFacturado += factura.getTotal();
                }
                request.setAttribute("totalFacturado", totalFacturado);

                // Obtener datos del cliente para mostrar
                ClienteDao clienteDao = new ClienteDao();
                Cliente cliente = clienteDao.obtenerClientePorId(idCliente);
                if (cliente != null) {
                    request.setAttribute("nombreCliente", cliente.getNombre() + " " + cliente.getApellido());
                }

                request.setAttribute("mensaje", "✅ Se encontraron " + facturas.size() + " facturas");
            } else {
                request.setAttribute("facturas", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron facturas para este cliente");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de cliente inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar facturas por cliente");
            return;
        }

        request.getRequestDispatcher("FacturasPorCliente.jsp").forward(request, response);
    }

    /**
     * Busca facturas con diversos criterios
     */
    private void buscarFacturas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String termino = limpiarParametro(request.getParameter("termino"));
            String fechaInicioStr = limpiarParametro(request.getParameter("fechaInicio"));
            String fechaFinStr = limpiarParametro(request.getParameter("fechaFin"));
            String estado = limpiarParametro(request.getParameter("estado"));

            FacturaDao dao = new FacturaDao();
            List<FacturaClienteDTO> facturas = null;

            // Búsqueda por diferentes criterios
            if (!termino.isEmpty()) {
                facturas = dao.buscarFacturas(termino);
            } else if (!fechaInicioStr.isEmpty() && !fechaFinStr.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Timestamp fechaInicio = new Timestamp(sdf.parse(fechaInicioStr).getTime());
                Timestamp fechaFin = new Timestamp(sdf.parse(fechaFinStr).getTime());
                
                // Validar rango de fechas
                if (fechaInicio.after(fechaFin)) {
                    request.setAttribute("mensaje", "❌ La fecha de inicio no puede ser mayor que la fecha fin");
                    request.getRequestDispatcher("BuscarFacturas.jsp").forward(request, response);
                    return;
                }
                
                facturas = dao.obtenerFacturasPorFecha(fechaInicio, fechaFin);
            } else if (!estado.isEmpty()) {
                facturas = dao.obtenerFacturasPorEstado(estado);
            } else {
                // Listar todas si no hay criterios específicos
                facturas = dao.listarTodasFacturas();
            }

            if (facturas != null && !facturas.isEmpty()) {
                request.setAttribute("facturas", facturas);
                request.setAttribute("totalFacturas", facturas.size());

                // Calcular estadísticas
                double totalFacturado = 0.0;
                int facturasPagadas = 0;
                int facturasPendientes = 0;

                for (FacturaClienteDTO factura : facturas) {
                    totalFacturado += factura.getTotal();
                    if ("PAGADA".equals(factura.getEstado())) {
                        facturasPagadas++;
                    } else if ("PENDIENTE".equals(factura.getEstado())) {
                        facturasPendientes++;
                    }
                }

                request.setAttribute("totalFacturado", totalFacturado);
                request.setAttribute("facturasPagadas", facturasPagadas);
                request.setAttribute("facturasPendientes", facturasPendientes);
                request.setAttribute("mensaje", "✅ Se encontraron " + facturas.size() + " facturas");
            } else {
                request.setAttribute("facturas", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron facturas con los criterios especificados");
            }

            // Mantener parámetros de búsqueda para el formulario
            request.setAttribute("terminoBusqueda", termino);
            request.setAttribute("fechaInicio", fechaInicioStr);
            request.setAttribute("fechaFin", fechaFinStr);
            request.setAttribute("estadoSeleccionado", estado);

        } catch (Exception e) {
            manejarError(request, response, e, "Error al buscar facturas");
            return;
        }

        request.getRequestDispatcher("BuscarFacturas.jsp").forward(request, response);
    }

    /**
     * Obtiene el detalle completo de una factura específica
     */
    private void obtenerDetalleFactura(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idFacturaStr = limpiarParametro(request.getParameter("idFactura"));

            if (idFacturaStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de factura requerido");
                request.getRequestDispatcher("BuscarFacturas.jsp").forward(request, response);
                return;
            }

            int idFactura = Integer.parseInt(idFacturaStr);

            FacturaDao dao = new FacturaDao();
            Factura factura = dao.obtenerFacturaPorId(idFactura);

            if (factura != null) {
                request.setAttribute("facturaDetalle", factura);
                request.setAttribute("mensaje", "✅ Detalle de factura cargado");
            } else {
                request.setAttribute("mensaje", "❌ Factura no encontrada");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de factura inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al obtener detalle de factura");
            return;
        }

        request.getRequestDispatcher("DetalleFactura.jsp").forward(request, response);
    }

    /**
     * Anula una factura existente
     */
    private void anularFactura(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idFacturaStr = limpiarParametro(request.getParameter("idFactura"));
            String motivo = limpiarParametro(request.getParameter("motivo"));

            if (idFacturaStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de factura requerido");
                request.getRequestDispatcher("BuscarFacturas.jsp").forward(request, response);
                return;
            }

            if (motivo.isEmpty()) {
                request.setAttribute("mensaje", "❌ Motivo de anulación es obligatorio");
                request.getRequestDispatcher("DetalleFactura.jsp").forward(request, response);
                return;
            }

            int idFactura = Integer.parseInt(idFacturaStr);

            FacturaDao dao = new FacturaDao();
            boolean exito = dao.anularFactura(idFactura, motivo);

            if (exito) {
                request.setAttribute("mensaje", "✅ Factura anulada exitosamente");
                request.setAttribute("tipoMensaje", "success");
            } else {
                request.setAttribute("mensaje", "❌ Error al anular la factura");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de factura inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al anular factura");
            return;
        }

        request.getRequestDispatcher("DetalleFactura.jsp").forward(request, response);
    }

    /**
     * Lista todas las facturas del sistema
     */
    private void listarTodasFacturas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            FacturaDao dao = new FacturaDao();
            List<FacturaClienteDTO> facturas = dao.listarTodasFacturas();

            if (facturas != null && !facturas.isEmpty()) {
                request.setAttribute("facturas", facturas);
                request.setAttribute("totalFacturas", facturas.size());

                // Estadísticas generales
                double totalFacturado = 0.0;
                for (FacturaClienteDTO factura : facturas) {
                    totalFacturado += factura.getTotal();
                }
                request.setAttribute("totalFacturado", totalFacturado);
                request.setAttribute("mensaje", "✅ Listado completo de facturas cargado");
            } else {
                request.setAttribute("facturas", null);
                request.setAttribute("mensaje", "ℹ️ No existen facturas en el sistema");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar todas las facturas");
            return;
        }

        request.getRequestDispatcher("ListaFacturas.jsp").forward(request, response);
    }

    /**
     * Manejo centralizado de errores
     */
    private void manejarError(HttpServletRequest request, HttpServletResponse response, 
                             Exception e, String mensajeContexto) 
            throws ServletException, IOException {
        
        System.err.println("=== ERROR EN FACTURA CONTROLADOR ===");
        System.err.println("Contexto: " + mensajeContexto);
        System.err.println("Mensaje: " + e.getMessage());
        e.printStackTrace();

        request.setAttribute("mensaje", "❌ " + mensajeContexto + ": " + e.getMessage());
        request.setAttribute("tipoMensaje", "error");
        
        request.getRequestDispatcher("UtilidadesFacturas.jsp").forward(request, response);
    }

    /**
     * Método auxiliar para limpiar parámetros
     */
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
        return "Controlador para gestión completa de facturas";
    }
}