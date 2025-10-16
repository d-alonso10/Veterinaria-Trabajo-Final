package control;

import dao.NotificacionDao;
import dao.ClienteDao;
import modelo.Notificacion;
import modelo.NotificacionClienteDTO;
import modelo.Cliente;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/NotificacionControlador"})
public class NotificacionControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");

        try {
            if (accion != null) {
                switch (accion) {
                    case "registrar":
                        registrarNotificacion(request, response);
                        break;
                    case "listarPorCliente":
                        listarNotificacionesPorCliente(request, response);
                        break;
                    case "marcarLeida":
                        marcarNotificacionLeida(request, response);
                        break;
                    case "marcarEnviada":
                        marcarNotificacionEnviada(request, response);
                        break;
                    case "buscarNotificaciones":
                        buscarNotificaciones(request, response);
                        break;
                    case "listarPendientes":
                        listarNotificacionesPendientes(request, response);
                        break;
                    case "listarTodasRecientes":
                        listarTodasNotificacionesRecientes(request, response);
                        break;
                    default:
                        response.sendRedirect("UtilidadesNotificaciones.jsp");
                }
            } else {
                response.sendRedirect("UtilidadesNotificaciones.jsp");
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error general en el controlador de notificaciones");
        }
    }

    /**
     * Registra una nueva notificación en el sistema
     */
    private void registrarNotificacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener parámetros
            String tipo = limpiarParametro(request.getParameter("tipo"));
            String destinatarioIdStr = limpiarParametro(request.getParameter("destinatarioId"));
            String canal = limpiarParametro(request.getParameter("canal"));
            String contenido = limpiarParametro(request.getParameter("contenido"));
            String referenciaTipo = limpiarParametro(request.getParameter("referenciaTipo"));
            String referenciaIdStr = limpiarParametro(request.getParameter("referenciaId"));

            // Validaciones básicas
            if (tipo.isEmpty() || destinatarioIdStr.isEmpty() || canal.isEmpty() || contenido.isEmpty()) {
                request.setAttribute("mensaje", "❌ Tipo, destinatario, canal y contenido son obligatorios");
                request.getRequestDispatcher("RegistrarNotificacion.jsp").forward(request, response);
                return;
            }

            // Validar tipos permitidos
            String[] tiposPermitidos = {"RECORDATORIO", "CONFIRMACION", "CANCELACION", "PROMOCION", "INFORMATIVO"};
            boolean tipoValido = false;
            for (String tipoPermitido : tiposPermitidos) {
                if (tipoPermitido.equals(tipo.toUpperCase())) {
                    tipo = tipoPermitido;
                    tipoValido = true;
                    break;
                }
            }

            if (!tipoValido) {
                request.setAttribute("mensaje", "❌ Tipo de notificación no válido");
                request.getRequestDispatcher("RegistrarNotificacion.jsp").forward(request, response);
                return;
            }

            // Validar canales permitidos
            String[] canalesPermitidos = {"EMAIL", "SMS", "WHATSAPP", "SISTEMA"};
            boolean canalValido = false;
            for (String canalPermitido : canalesPermitidos) {
                if (canalPermitido.equals(canal.toUpperCase())) {
                    canal = canalPermitido;
                    canalValido = true;
                    break;
                }
            }

            if (!canalValido) {
                request.setAttribute("mensaje", "❌ Canal de notificación no válido");
                request.getRequestDispatcher("RegistrarNotificacion.jsp").forward(request, response);
                return;
            }

            // Validar contenido
            if (contenido.length() > 500) {
                request.setAttribute("mensaje", "❌ El contenido no puede exceder 500 caracteres");
                request.getRequestDispatcher("RegistrarNotificacion.jsp").forward(request, response);
                return;
            }

            // Conversiones numéricas
            int destinatarioId, referenciaId = 0;
            try {
                destinatarioId = Integer.parseInt(destinatarioIdStr);
                if (destinatarioId <= 0) {
                    throw new NumberFormatException("ID debe ser positivo");
                }

                if (!referenciaIdStr.isEmpty()) {
                    referenciaId = Integer.parseInt(referenciaIdStr);
                    if (referenciaId <= 0) {
                        throw new NumberFormatException("ID de referencia debe ser positivo");
                    }
                }
            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ IDs proporcionados inválidos");
                request.getRequestDispatcher("RegistrarNotificacion.jsp").forward(request, response);
                return;
            }

            // Validar que el cliente existe
            ClienteDao clienteDao = new ClienteDao();
            Cliente cliente = clienteDao.obtenerClientePorId(destinatarioId);
            if (cliente == null) {
                request.setAttribute("mensaje", "❌ Cliente destinatario no encontrado");
                request.getRequestDispatcher("RegistrarNotificacion.jsp").forward(request, response);
                return;
            }

            // Crear objeto Notificacion
            Notificacion notificacion = new Notificacion();
            notificacion.setTipo(tipo);
            notificacion.setDestinatarioId(destinatarioId);
            notificacion.setCanal(canal);
            notificacion.setContenido(contenido);
            notificacion.setReferenciaTipo(referenciaTipo.isEmpty() ? null : referenciaTipo);
            notificacion.setReferenciaId(referenciaId == 0 ? 0 : referenciaId);

            // Registrar notificación
            NotificacionDao dao = new NotificacionDao();
            boolean exito = dao.registrarNotificacion(notificacion);

            if (exito) {
                request.setAttribute("mensaje", "✅ Notificación registrada exitosamente");
                request.setAttribute("tipoMensaje", "success");
                
                // Limpiar formulario
                request.removeAttribute("tipo");
                request.removeAttribute("destinatarioId");
                request.removeAttribute("canal");
                request.removeAttribute("contenido");
                request.removeAttribute("referenciaTipo");
                request.removeAttribute("referenciaId");
            } else {
                request.setAttribute("mensaje", "❌ Error al registrar la notificación");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al registrar notificación");
            return;
        }

        request.getRequestDispatcher("RegistrarNotificacion.jsp").forward(request, response);
    }

    /**
     * Lista notificaciones de un cliente específico
     */
    private void listarNotificacionesPorCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String destinatarioIdStr = limpiarParametro(request.getParameter("destinatarioId"));
            String limiteStr = limpiarParametro(request.getParameter("limite"));

            if (destinatarioIdStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID del cliente requerido");
                request.getRequestDispatcher("BuscarNotificaciones.jsp").forward(request, response);
                return;
            }

            int destinatarioId = Integer.parseInt(destinatarioIdStr);
            Integer limite = null;

            if (!limiteStr.isEmpty()) {
                try {
                    int limiteParsed = Integer.parseInt(limiteStr);
                    if (limiteParsed > 0 && limiteParsed <= 100) {
                        limite = limiteParsed;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "⚠️ Límite inválido, usando valor por defecto");
                }
            }

            NotificacionDao dao = new NotificacionDao();
            List<NotificacionClienteDTO> notificaciones = dao.obtenerNotificacionesCliente(destinatarioId, limite);

            if (notificaciones != null && !notificaciones.isEmpty()) {
                request.setAttribute("notificaciones", notificaciones);
                request.setAttribute("totalNotificaciones", notificaciones.size());
                request.setAttribute("destinatarioIdConsulta", destinatarioId);

                // Obtener información del cliente
                ClienteDao clienteDao = new ClienteDao();
                Cliente cliente = clienteDao.obtenerClientePorId(destinatarioId);
                if (cliente != null) {
                    request.setAttribute("nombreCliente", cliente.getNombre() + " " + cliente.getApellido());
                }

                // Contar por estado
                int pendientes = 0, enviadas = 0, leidas = 0;
                for (NotificacionClienteDTO notif : notificaciones) {
                    switch (notif.getEstado()) {
                        case "PENDIENTE":
                            pendientes++;
                            break;
                        case "ENVIADA":
                            enviadas++;
                            break;
                        case "LEIDA":
                            leidas++;
                            break;
                    }
                }

                request.setAttribute("notificacionesPendientes", pendientes);
                request.setAttribute("notificacionesEnviadas", enviadas);
                request.setAttribute("notificacionesLeidas", leidas);
                request.setAttribute("mensaje", "✅ Se encontraron " + notificaciones.size() + " notificaciones");
            } else {
                request.setAttribute("notificaciones", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron notificaciones para este cliente");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de cliente inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar notificaciones por cliente");
            return;
        }

        request.getRequestDispatcher("NotificacionesPorCliente.jsp").forward(request, response);
    }

    /**
     * Marca una notificación como leída
     */
    private void marcarNotificacionLeida(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idNotificacionStr = limpiarParametro(request.getParameter("idNotificacion"));

            if (idNotificacionStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de notificación requerido");
                request.getRequestDispatcher("UtilidadesNotificaciones.jsp").forward(request, response);
                return;
            }

            int idNotificacion = Integer.parseInt(idNotificacionStr);

            NotificacionDao dao = new NotificacionDao();
            boolean exito = dao.marcarNotificacionLeida(idNotificacion);

            if (exito) {
                request.setAttribute("mensaje", "✅ Notificación marcada como leída");
                request.setAttribute("tipoMensaje", "success");
            } else {
                request.setAttribute("mensaje", "❌ Error al marcar notificación como leída");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de notificación inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al marcar notificación como leída");
            return;
        }

        request.getRequestDispatcher("UtilidadesNotificaciones.jsp").forward(request, response);
    }

    /**
     * Marca una notificación como enviada
     */
    private void marcarNotificacionEnviada(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idNotificacionStr = limpiarParametro(request.getParameter("idNotificacion"));

            if (idNotificacionStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de notificación requerido");
                request.getRequestDispatcher("UtilidadesNotificaciones.jsp").forward(request, response);
                return;
            }

            int idNotificacion = Integer.parseInt(idNotificacionStr);

            NotificacionDao dao = new NotificacionDao();
            boolean exito = dao.marcarNotificacionEnviada(idNotificacion);

            if (exito) {
                request.setAttribute("mensaje", "✅ Notificación marcada como enviada");
                request.setAttribute("tipoMensaje", "success");
            } else {
                request.setAttribute("mensaje", "❌ Error al marcar notificación como enviada");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de notificación inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al marcar notificación como enviada");
            return;
        }

        request.getRequestDispatcher("UtilidadesNotificaciones.jsp").forward(request, response);
    }

    /**
     * Busca notificaciones por diferentes criterios
     */
    private void buscarNotificaciones(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String tipo = limpiarParametro(request.getParameter("tipo"));
            String canal = limpiarParametro(request.getParameter("canal"));
            String estado = limpiarParametro(request.getParameter("estado"));
            String contenido = limpiarParametro(request.getParameter("contenido"));

            NotificacionDao dao = new NotificacionDao();
            List<NotificacionClienteDTO> notificaciones = dao.buscarNotificaciones(tipo, canal, estado, contenido);

            if (notificaciones != null && !notificaciones.isEmpty()) {
                request.setAttribute("notificaciones", notificaciones);
                request.setAttribute("totalNotificaciones", notificaciones.size());
                request.setAttribute("mensaje", "✅ Se encontraron " + notificaciones.size() + " notificaciones");

                // Estadísticas de búsqueda
                int porTipo = 0, porCanal = 0, porEstado = 0;
                for (NotificacionClienteDTO notif : notificaciones) {
                    if (!tipo.isEmpty() && tipo.equals(notif.getTipo())) porTipo++;
                    if (!canal.isEmpty() && canal.equals(notif.getCanal())) porCanal++;
                    if (!estado.isEmpty() && estado.equals(notif.getEstado())) porEstado++;
                }
                
                request.setAttribute("coincidenciasTipo", porTipo);
                request.setAttribute("coincidenciasCanal", porCanal);
                request.setAttribute("coincidenciasEstado", porEstado);
            } else {
                request.setAttribute("notificaciones", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron notificaciones con los criterios especificados");
            }

            // Mantener parámetros de búsqueda
            request.setAttribute("tipoBusqueda", tipo);
            request.setAttribute("canalBusqueda", canal);
            request.setAttribute("estadoBusqueda", estado);
            request.setAttribute("contenidoBusqueda", contenido);

        } catch (Exception e) {
            manejarError(request, response, e, "Error al buscar notificaciones");
            return;
        }

        request.getRequestDispatcher("BuscarNotificaciones.jsp").forward(request, response);
    }

    /**
     * Lista notificaciones pendientes de envío
     */
    private void listarNotificacionesPendientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            NotificacionDao dao = new NotificacionDao();
            List<NotificacionClienteDTO> notificaciones = dao.obtenerNotificacionesPendientes();

            if (notificaciones != null && !notificaciones.isEmpty()) {
                request.setAttribute("notificacionesPendientes", notificaciones);
                request.setAttribute("totalPendientes", notificaciones.size());
                request.setAttribute("mensaje", "✅ Se encontraron " + notificaciones.size() + " notificaciones pendientes");
            } else {
                request.setAttribute("notificacionesPendientes", null);
                request.setAttribute("mensaje", "ℹ️ No hay notificaciones pendientes de envío");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar notificaciones pendientes");
            return;
        }

        request.getRequestDispatcher("NotificacionesPendientes.jsp").forward(request, response);
    }

    /**
     * Lista todas las notificaciones recientes del sistema
     */
    private void listarTodasNotificacionesRecientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String limiteStr = limpiarParametro(request.getParameter("limite"));
            int limite = 50; // Por defecto

            if (!limiteStr.isEmpty()) {
                try {
                    int limiteParsed = Integer.parseInt(limiteStr);
                    if (limiteParsed > 0 && limiteParsed <= 500) {
                        limite = limiteParsed;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "⚠️ Límite inválido, usando valor por defecto (50)");
                }
            }

            NotificacionDao dao = new NotificacionDao();
            List<NotificacionClienteDTO> notificaciones = dao.obtenerNotificacionesRecientes(limite);

            if (notificaciones != null && !notificaciones.isEmpty()) {
                request.setAttribute("notificaciones", notificaciones);
                request.setAttribute("totalNotificaciones", notificaciones.size());
                request.setAttribute("limiteAplicado", limite);
                request.setAttribute("mensaje", "✅ Últimas " + notificaciones.size() + " notificaciones del sistema");
            } else {
                request.setAttribute("notificaciones", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron notificaciones recientes");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar notificaciones recientes");
            return;
        }

        request.getRequestDispatcher("NotificacionesRecientes.jsp").forward(request, response);
    }

    /**
     * Manejo centralizado de errores
     */
    private void manejarError(HttpServletRequest request, HttpServletResponse response, 
                             Exception e, String mensajeContexto) 
            throws ServletException, IOException {
        
        System.err.println("=== ERROR EN NOTIFICACION CONTROLADOR ===");
        System.err.println("Contexto: " + mensajeContexto);
        System.err.println("Mensaje: " + e.getMessage());
        e.printStackTrace();

        request.setAttribute("mensaje", "❌ " + mensajeContexto + ": " + e.getMessage());
        request.setAttribute("tipoMensaje", "error");
        
        request.getRequestDispatcher("UtilidadesNotificaciones.jsp").forward(request, response);
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
        return "Controlador para gestión completa de notificaciones";
    }
}