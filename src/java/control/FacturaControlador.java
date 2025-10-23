package control;

import dao.FacturaDao;
import dao.ClienteDao;
import dao.ServicioDao; // Aunque no se usa directamente en los métodos corregidos, es bueno mantenerlo para mostrarFormularioCreacion
import modelo.Factura;
import modelo.FacturaClienteDTO; // Importar el DTO
import modelo.Cliente;
import modelo.Servicio;
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
                    case "listar":
                    case "listarTodas":
                        listarTodasFacturas(request, response);
                        break;
                    case "mostrarFormulario":
                        mostrarFormularioCreacion(request, response);
                        break;
                    case "mostrarBusqueda":
                        mostrarFormularioBusqueda(request, response);
                        break;
                    default:
                        listarTodasFacturas(request, response);
                }
            } else {
                listarTodasFacturas(request, response);
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
        
        String vistaError = "CrearFactura.jsp"; // Vista para mostrar errores
        
        try {
            // Obtener parámetros
            String serieStr = limpiarParametro(request.getParameter("serie"));
            String numeroStr = limpiarParametro(request.getParameter("numero"));
            String idAtencionStr = limpiarParametro(request.getParameter("idAtencion"));
            String metodoPago = limpiarParametro(request.getParameter("metodoPago"));

            // Validaciones básicas
            if (serieStr.isEmpty() || numeroStr.isEmpty() || idAtencionStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Serie, número y atención son obligatorios");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            // Validar formato de serie y número
            if (!serieStr.matches("[A-Z0-9]{1,4}")) { // Permitir números en serie (ej. F001)
                request.setAttribute("mensaje", "❌ Serie debe contener letras mayúsculas o números (1-4 caracteres)");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            if (!numeroStr.matches("\\d{1,8}")) {
                request.setAttribute("mensaje", "❌ Número debe contener solo dígitos (1-8 caracteres)");
                request.getRequestDispatcher(vistaError).forward(request, response);
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
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            // Validar método de pago (usando los valores de la BD)
            if (metodoPago.isEmpty()) {
                metodoPago = "efectivo"; // Valor por defecto
            }
            // Lista de métodos válidos según el ENUM de la BD
            String[] metodosValidos = {"efectivo", "tarjeta", "transfer", "otro"};
            boolean metodovalido = false;
            for (String metodo : metodosValidos) {
                if (metodo.equalsIgnoreCase(metodoPago)) { // Usar equalsIgnoreCase
                    metodoPago = metodo; // Asignar el valor limpio
                    metodovalido = true;
                    break;
                }
            }
            if (!metodovalido) {
                request.setAttribute("mensaje", "❌ Método de pago no válido");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
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
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/FacturaControlador?accion=listar&creada=exito&serie=" + serieStr + "&numero=" + numeroStr);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al crear la factura. Verifique que la serie y número no estén duplicados, o que la atención exista.");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (Exception e) {
             request.setAttribute("mensaje", "❌ Error del sistema al crear la factura: " + e.getMessage());
             request.setAttribute("tipoMensaje", "error");
        }

        // Solo usar forward en caso de error para mostrar el mensaje en el formulario
        request.getRequestDispatcher(vistaError).forward(request, response);
    }

    /**
     * Lista facturas por cliente específico
     */
    private void listarFacturasPorCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String vistaDestino = "FacturasPorCliente.jsp"; // Vista para mostrar los resultados
        
        try {
            String idClienteStr = limpiarParametro(request.getParameter("idCliente"));

            if (idClienteStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de cliente requerido");
                request.getRequestDispatcher("BuscarFacturas.jsp").forward(request, response);
                return;
            }

            int idCliente = Integer.parseInt(idClienteStr);

            FacturaDao dao = new FacturaDao();
            
            // ****** INICIO DE CORRECCIÓN (Coherencia DAO/Modelo) ******
            // Usar FacturaClienteDTO para obtener también los datos del cliente
            List<FacturaClienteDTO> facturas = dao.obtenerFacturasPorCliente(idCliente);
            // ****** FIN DE CORRECCIÓN ******

            if (facturas != null && !facturas.isEmpty()) {
                request.setAttribute("facturas", facturas); // Ahora es List<FacturaClienteDTO>
                request.setAttribute("totalFacturas", facturas.size());
                request.setAttribute("idClienteConsulta", idCliente);

                // Calcular totales
                double totalFacturado = 0.0;
                for (FacturaClienteDTO factura : facturas) { // Iterar sobre DTO
                    totalFacturado += factura.getTotal();
                }
                request.setAttribute("totalFacturado", totalFacturado);

                // Obtener datos del cliente (ya vienen en el DTO, pero podemos tomar el primero)
                request.setAttribute("nombreCliente", facturas.get(0).getNombreCliente() + " " + facturas.get(0).getApellidoCliente());

                request.setAttribute("mensaje", "✅ Se encontraron " + facturas.size() + " facturas");
            } else {
                request.setAttribute("facturas", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron facturas para este cliente");
                
                // Si no hay facturas, igual intentar obtener el nombre del cliente para la vista
                ClienteDao clienteDao = new ClienteDao();
                Cliente cliente = clienteDao.obtenerClientePorId(idCliente);
                if (cliente != null) {
                    request.setAttribute("nombreCliente", cliente.getNombre() + " " + cliente.getApellido());
                }
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de cliente inválido");
            request.getRequestDispatcher("BuscarFacturas.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar facturas por cliente");
            return;
        }

        request.getRequestDispatcher(vistaDestino).forward(request, response);
    }

    /**
     * Busca facturas con diversos criterios
     */
    private void buscarFacturas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String vistaDestino = "BuscarFacturas.jsp"; // La misma vista muestra el formulario y los resultados
        
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
                // Ajustar para incluir el día completo en la fecha fin
                Timestamp fechaInicio = new Timestamp(sdf.parse(fechaInicioStr).getTime());
                Timestamp fechaFin = new Timestamp(sdf.parse(fechaFinStr).getTime() + (24 * 60 * 60 * 1000 - 1)); // +23:59:59.999
                
                if (fechaInicio.after(fechaFin)) {
                    request.setAttribute("mensaje", "❌ La fecha de inicio no puede ser mayor que la fecha fin");
                    request.getRequestDispatcher(vistaDestino).forward(request, response);
                    return;
                }
                
                facturas = dao.obtenerFacturasPorFecha(fechaInicio, fechaFin);
            } else if (!estado.isEmpty()) {
                facturas = dao.obtenerFacturasPorEstado(estado);
            } else {
                // No listar todas por defecto en una búsqueda, mejor pedir criterios
                request.setAttribute("mensaje", "ℹ️ Ingrese un término, rango de fechas o estado para buscar.");
                request.getRequestDispatcher(vistaDestino).forward(request, response);
                return;
            }

            if (facturas != null && !facturas.isEmpty()) {
                request.setAttribute("facturas", facturas);
                request.setAttribute("totalFacturas", facturas.size());

                // Calcular estadísticas
                double totalFacturado = 0.0;
                int facturasEmitidas = 0; // Cambiado de "pagadas"
                int facturasAnuladas = 0; // Cambiado de "pendientes"

                for (FacturaClienteDTO factura : facturas) {
                    if ("emitida".equalsIgnoreCase(factura.getEstado())) {
                         totalFacturado += factura.getTotal(); // Solo sumar las emitidas
                         facturasEmitidas++;
                    } else if ("anulada".equalsIgnoreCase(factura.getEstado())) {
                        facturasAnuladas++;
                    }
                }

                request.setAttribute("totalFacturado", totalFacturado);
                request.setAttribute("facturasEmitidas", facturasEmitidas);
                request.setAttribute("facturasAnuladas", facturasAnuladas);
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

        request.getRequestDispatcher(vistaDestino).forward(request, response);
    }

    /**
     * Obtiene el detalle completo de una factura específica
     */
    private void obtenerDetalleFactura(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String vistaDestino = "DetalleFactura.jsp";
        
        try {
            String idFacturaStr = limpiarParametro(request.getParameter("idFactura"));

            if (idFacturaStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de factura requerido");
                request.getRequestDispatcher("BuscarFacturas.jsp").forward(request, response);
                return;
            }

            int idFactura = Integer.parseInt(idFacturaStr);

            FacturaDao dao = new FacturaDao();
            FacturaClienteDTO factura = dao.obtenerFacturaPorId(idFactura); // Usar DTO

            if (factura != null) {
                request.setAttribute("facturaDetalle", factura);
                // Cargar también los detalles de servicios y pagos si es necesario para esta vista
                // ... (llamar a DetalleServicioDao y PagoDao)
                request.setAttribute("mensaje", "✅ Detalle de factura cargado");
            } else {
                request.setAttribute("mensaje", "❌ Factura no encontrada");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de factura inválido");
            request.getRequestDispatcher("BuscarFacturas.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            manejarError(request, response, e, "Error al obtener detalle de factura");
            return;
        }

        request.getRequestDispatcher(vistaDestino).forward(request, response);
    }

    /**
     * Anula una factura existente
     */
    private void anularFactura(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idFacturaStr = limpiarParametro(request.getParameter("idFactura"));
        String vistaError = "DetalleFactura.jsp"; // Volver al detalle si falla
        
        try {
            String motivo = limpiarParametro(request.getParameter("motivo")); // Motivo es opcional en el DAO actual

            if (idFacturaStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de factura requerido");
                request.getRequestDispatcher("BuscarFacturas.jsp").forward(request, response);
                return;
            }

            // (Opcional) Validación de motivo si se hace obligatorio
            // if (motivo.isEmpty()) {
            //     request.setAttribute("mensaje", "❌ Motivo de anulación es obligatorio");
            //     request.getRequestDispatcher(vistaError).forward(request, response);
            //     return;
            // }

            int idFactura = Integer.parseInt(idFacturaStr);

            FacturaDao dao = new FacturaDao();
            boolean exito = dao.anularFactura(idFactura, motivo); // Pasar motivo

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/FacturaControlador?accion=listar&anulada=exito&id=" + idFactura);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al anular la factura (quizás ya estaba anulada)");
                request.setAttribute("tipoMensaje", "error");
                // Recargar datos para la vista de error
                FacturaClienteDTO factura = dao.obtenerFacturaPorId(idFactura);
                request.setAttribute("facturaDetalle", factura);
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de factura inválido");
            request.getRequestDispatcher(vistaError).forward(request, response);
            return;
        } catch (Exception e) {
            manejarError(request, response, e, "Error al anular factura");
            return;
        }
    }

    /**
     * Lista todas las facturas del sistema
     */
    private void listarTodasFacturas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String vistaDestino = "ListaFacturas.jsp";
        
        try {
            // ****** INICIO CORRECCIÓN (Manejar mensajes PRG) ******
            String creada = request.getParameter("creada");
            String anulada = request.getParameter("anulada");
            String idParam = request.getParameter("id");
            String serie = request.getParameter("serie");
            String numero = request.getParameter("numero");

            if ("exito".equals(creada)) {
                String facturaInfo = (serie != null && numero != null) ? " (" + serie + "-" + numero + ")" : "";
                request.setAttribute("mensaje", "✅ Factura creada exitosamente" + facturaInfo);
                request.setAttribute("tipoMensaje", "exito");
            } else if ("exito".equals(anulada)) {
                request.setAttribute("mensaje", "✅ Factura ID " + idParam + " anulada exitosamente.");
                request.setAttribute("tipoMensaje", "exito");
            }
            // ****** FIN CORRECCIÓN ******

            FacturaDao dao = new FacturaDao();
            List<FacturaClienteDTO> facturas = dao.listarTodasFacturas();

            if (facturas != null && !facturas.isEmpty()) {
                request.setAttribute("facturas", facturas);
                request.setAttribute("totalFacturas", facturas.size());

                // Estadísticas generales
                double totalFacturado = 0.0;
                int facturasEmitidas = 0;
                int facturasAnuladas = 0;
                
                for (FacturaClienteDTO factura : facturas) {
                    if ("emitida".equalsIgnoreCase(factura.getEstado())) {
                        totalFacturado += factura.getTotal();
                        facturasEmitidas++;
                    } else if ("anulada".equalsIgnoreCase(factura.getEstado())) {
                        facturasAnuladas++;
                    }
                }
                request.setAttribute("totalFacturado", totalFacturado);
                request.setAttribute("facturasEmitidas", facturasEmitidas);
                request.setAttribute("facturasAnuladas", facturasAnuladas);
                
                if (request.getAttribute("mensaje") == null) { // No sobreescribir mensajes de éxito
                    request.setAttribute("mensaje", "✅ Listado completo de facturas cargado");
                }
            } else {
                 if (request.getAttribute("mensaje") == null) {
                    request.setAttribute("facturas", null);
                    request.setAttribute("mensaje", "ℹ️ No existen facturas en el sistema");
                 }
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar todas las facturas");
            return;
        }

        request.getRequestDispatcher(vistaDestino).forward(request, response);
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
        
        // Redirigir a una vista principal o de error
        request.getRequestDispatcher("ListaFacturas.jsp").forward(request, response);
    }

    /**
     * Muestra el formulario para crear una nueva factura
     */
    private void mostrarFormularioCreacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Cargar clientes para el formulario
            ClienteDao clienteDao = new ClienteDao();
            List<Cliente> clientes = clienteDao.buscarClientes(""); // Asume que buscar con "" lista todos
            request.setAttribute("clientes", clientes);
            
            // Cargar servicios para el formulario
            ServicioDao servicioDao = new ServicioDao();
            List<Servicio> servicios = servicioDao.obtenerServicios(); // Asume que este método existe
            request.setAttribute("servicios", servicios);
            
            // Cargar atenciones pendientes de facturar (¡NUEVO!)
            // Esto es crucial para el formulario
            // Necesitarías un AtencionDao.listarAtencionesPendientesDeFactura()
            // AtencionDao atencionDao = new AtencionDao();
            // List<Atencion> atenciones = atencionDao.listarAtencionesPendientesDeFactura();
            // request.setAttribute("atenciones", atenciones);
            
            request.getRequestDispatcher("/CrearFactura.jsp").forward(request, response);
        } catch (Exception e) {
            manejarError(request, response, e, "Error al mostrar formulario de creación de factura");
        }
    }

    /**
     * Muestra el formulario de búsqueda de facturas
     */
    private void mostrarFormularioBusqueda(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.getRequestDispatcher("/BuscarFacturas.jsp").forward(request, response);
        } catch (Exception e) {
            manejarError(request, response, e, "Error al mostrar formulario de búsqueda");
        }
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