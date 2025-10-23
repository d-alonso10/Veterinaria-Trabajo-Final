package control;

import dao.NotificacionDao;
import dao.ClienteDao;
import modelo.Notificacion;
import modelo.NotificacionClienteDTO;
import modelo.Cliente;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
                    case "mostrarFormulario":
                        mostrarFormularioCreacion(request, response);
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
                mostrarFormularioConClientes(request, response);
                return;
            }

            // Validar tipos permitidos (según el modelo y DAO)
            String[] tiposPermitidos = {"email", "sms", "push", "recordatorio", "confirmacion", "cancelacion", "promocion", "informativo"};
            boolean tipoValido = false;
            for (String tipoPermitido : tiposPermitidos) {
                if (tipoPermitido.equalsIgnoreCase(tipo)) {
                    tipo = tipoPermitido.toLowerCase();
                    tipoValido = true;
                    break;
                }
            }

            if (!tipoValido) {
                request.setAttribute("mensaje", "❌ Tipo de notificación no válido. Use: email, sms, push, recordatorio, confirmacion, cancelacion, promocion o informativo");
                mostrarFormularioConClientes(request, response);
                return;
            }

            // Validar canales permitidos (según el modelo y DAO)
            String[] canalesPermitidos = {"email", "sms", "whatsapp", "sistema", "push"};
            boolean canalValido = false;
            for (String canalPermitido : canalesPermitidos) {
                if (canalPermitido.equalsIgnoreCase(canal)) {
                    canal = canalPermitido.toLowerCase();
                    canalValido = true;
                    break;
                }
            }

            if (!canalValido) {
                request.setAttribute("mensaje", "❌ Canal de notificación no válido. Use: email, sms, whatsapp, sistema o push");
                mostrarFormularioConClientes(request, response);
                return;
            }

            // Validar contenido
            if (contenido.length() > 500) {
                request.setAttribute("mensaje", "❌ El contenido no puede exceder 500 caracteres");
                mostrarFormularioConClientes(request, response);
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
                mostrarFormularioConClientes(request, response);
                return;
            }

            // Validar que el cliente existe
            ClienteDao clienteDao = new ClienteDao();
            Cliente cliente = clienteDao.obtenerClientePorId(destinatarioId);
            if (cliente == null) {
                request.setAttribute("mensaje", "❌ Cliente destinatario no encontrado");
                mostrarFormularioConClientes(request, response);
                return;
            }

            // Crear objeto Notificacion según el modelo
            Notificacion notificacion = new Notificacion();
            notificacion.setTipo(tipo);
            notificacion.setDestinatarioId(destinatarioId);
            notificacion.setCanal(canal);
            notificacion.setContenido(contenido);
            notificacion.setReferenciaTipo(referenciaTipo.isEmpty() ? null : referenciaTipo);
            notificacion.setReferenciaId(referenciaId);
            
            // El estado y fechas se manejan automáticamente en el DAO/procedimiento almacenado

            // Registrar notificación
            NotificacionDao dao = new NotificacionDao();
            boolean exito = dao.registrarNotificacion(notificacion);

            if (exito) {
                // ✅ PRG PATTERN: Redirigir después de POST exitoso
                response.sendRedirect(request.getContextPath() + "/NotificacionControlador?accion=mostrarFormulario&registrada=exito&tipo=" + tipo);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al registrar la notificación");
                request.setAttribute("tipoMensaje", "error");
                mostrarFormularioConClientes(request, response);
                return;
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al registrar notificación");
        }
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
                    request.setAttribute("clienteInfo", cliente);
                }

                // Contar por estado (según el modelo: 'pendiente', 'enviado')
                int pendientes = 0, enviadas = 0, leidas = 0;
                for (NotificacionClienteDTO notif : notificaciones) {
                    if ("pendiente".equalsIgnoreCase(notif.getEstado())) {
                        pendientes++;
                    } else if ("enviado".equalsIgnoreCase(notif.getEstado())) {
                        enviadas++;
                    } else if ("leido".equalsIgnoreCase(notif.getEstado())) {
                        leidas++;
                    }
                }

                request.setAttribute("notificacionesPendientes", pendientes);
                request.setAttribute("notificacionesEnviadas", enviadas);
                request.setAttribute("notificacionesLeidas", leidas);
                request.setAttribute("mensaje", "✅ Se encontraron " + notificaciones.size() + " notificaciones");
                
                // Calcular estadísticas adicionales
                calcularEstadisticasNotificaciones(request, notificaciones);
                
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
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                String referer = request.getHeader("Referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer + "&marcada=leida&id=" + idNotificacion);
                } else {
                    response.sendRedirect(request.getContextPath() + "/NotificacionControlador?accion=listarTodasRecientes&marcada=leida&id=" + idNotificacion);
                }
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al marcar notificación como leída. Puede que ya esté leída o no exista.");
                request.setAttribute("tipoMensaje", "error");
                request.getRequestDispatcher("UtilidadesNotificaciones.jsp").forward(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de notificación inválido");
            request.getRequestDispatcher("UtilidadesNotificaciones.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            manejarError(request, response, e, "Error al marcar notificación como leída");
        }
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
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                String referer = request.getHeader("Referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer + "&marcada=enviada&id=" + idNotificacion);
                } else {
                    response.sendRedirect(request.getContextPath() + "/NotificacionControlador?accion=listarPendientes&marcada=enviada&id=" + idNotificacion);
                }
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al marcar notificación como enviada");
                request.setAttribute("tipoMensaje", "error");
                request.getRequestDispatcher("UtilidadesNotificaciones.jsp").forward(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de notificación inválido");
            request.getRequestDispatcher("UtilidadesNotificaciones.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            manejarError(request, response, e, "Error al marcar notificación como enviada");
        }
    }

    /**
     * Busca notificaciones por diferentes criterios
     */
    private void buscarNotificaciones(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String tipo = limpiarParametro(request.getParameter("tipo"));
            String estado = limpiarParametro(request.getParameter("estado"));
            String contenido = limpiarParametro(request.getParameter("contenido"));

            // En NotificacionClienteDTO no tenemos canal, así que lo quitamos de la búsqueda
            NotificacionDao dao = new NotificacionDao();
            List<NotificacionClienteDTO> notificaciones = dao.buscarNotificaciones(tipo, null, estado, contenido);

            if (notificaciones != null && !notificaciones.isEmpty()) {
                request.setAttribute("notificaciones", notificaciones);
                request.setAttribute("totalNotificaciones", notificaciones.size());
                request.setAttribute("mensaje", "✅ Se encontraron " + notificaciones.size() + " notificaciones");

                // Estadísticas de búsqueda - solo por tipo y estado (sin canal)
                int porTipo = 0, porEstado = 0;
                for (NotificacionClienteDTO notif : notificaciones) {
                    if (!tipo.isEmpty() && tipo.equalsIgnoreCase(notif.getTipo())) porTipo++;
                    if (!estado.isEmpty() && estado.equalsIgnoreCase(notif.getEstado())) porEstado++;
                }
                
                request.setAttribute("coincidenciasTipo", porTipo);
                request.setAttribute("coincidenciasEstado", porEstado);
                
                // Calcular estadísticas generales
                calcularEstadisticasNotificaciones(request, notificaciones);
            } else {
                request.setAttribute("notificaciones", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron notificaciones con los criterios especificados");
            }

            // Mantener parámetros de búsqueda
            request.setAttribute("tipoBusqueda", tipo);
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
                
                // Calcular estadísticas
                calcularEstadisticasNotificaciones(request, notificaciones);
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
            Integer limite = 50; // Por defecto

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
                
                // Calcular estadísticas
                calcularEstadisticasNotificaciones(request, notificaciones);
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
     * Muestra el formulario para crear una nueva notificación
     */
    private void mostrarFormularioCreacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Verificar si viene de un registro exitoso
            String registrada = request.getParameter("registrada");
            String tipo = request.getParameter("tipo");
            if ("exito".equals(registrada)) {
                String tipoInfo = (tipo != null) ? " de tipo " + tipo : "";
                request.setAttribute("mensaje", "✅ Notificación" + tipoInfo + " registrada exitosamente");
                request.setAttribute("tipoMensaje", "exito");
            }

            mostrarFormularioConClientes(request, response);
            
        } catch (Exception e) {
            manejarError(request, response, e, "Error al mostrar formulario de creación de notificación");
        }
    }

    /**
     * Método auxiliar para cargar clientes y mostrar formulario
     */
    private void mostrarFormularioConClientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Cargar clientes para el formulario
            ClienteDao clienteDao = new ClienteDao();
            List<Cliente> clientes = clienteDao.listarTodosClientes();
            request.setAttribute("clientes", clientes);
            
            request.getRequestDispatcher("/CrearNotificacion.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Error al cargar lista de clientes", e);
        }
    }

    /**
     * Método auxiliar para calcular estadísticas de notificaciones
     */
    private void calcularEstadisticasNotificaciones(HttpServletRequest request, List<NotificacionClienteDTO> notificaciones) {
        if (notificaciones == null || notificaciones.isEmpty()) {
            return;
        }

        // Contadores por tipo
        int emails = 0, sms = 0, push = 0, recordatorios = 0, confirmaciones = 0, otros = 0;
        
        // Contadores por estado
        int pendientes = 0, enviadas = 0, leidas = 0;

        for (NotificacionClienteDTO notif : notificaciones) {
            // Contar por tipo
            if (notif.getTipo() != null) {
                String tipo = notif.getTipo().toLowerCase();
                if (tipo.equals("email")) {
                    emails++;
                } else if (tipo.equals("sms")) {
                    sms++;
                } else if (tipo.equals("push")) {
                    push++;
                } else if (tipo.equals("recordatorio")) {
                    recordatorios++;
                } else if (tipo.equals("confirmacion")) {
                    confirmaciones++;
                } else {
                    otros++;
                }
            }
            
            // Contar por estado
            if (notif.getEstado() != null) {
                String estado = notif.getEstado().toLowerCase();
                if (estado.equals("pendiente")) {
                    pendientes++;
                } else if (estado.equals("enviado")) {
                    enviadas++;
                } else if (estado.equals("leido")) {
                    leidas++;
                }
            }
        }

        // Agregar estadísticas al request usando HashMap (compatible con Java 8)
        Map<String, Integer> estadisticasTipo = new HashMap<>();
        estadisticasTipo.put("emails", emails);
        estadisticasTipo.put("sms", sms);
        estadisticasTipo.put("push", push);
        estadisticasTipo.put("recordatorios", recordatorios);
        estadisticasTipo.put("confirmaciones", confirmaciones);
        estadisticasTipo.put("otros", otros);
        request.setAttribute("estadisticasTipo", estadisticasTipo);
        
        Map<String, Integer> estadisticasEstado = new HashMap<>();
        estadisticasEstado.put("pendientes", pendientes);
        estadisticasEstado.put("enviadas", enviadas);
        estadisticasEstado.put("leidas", leidas);
        request.setAttribute("estadisticasEstado", estadisticasEstado);
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