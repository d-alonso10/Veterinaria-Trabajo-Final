package control;

import dao.AtencionDao;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Atencion;
import modelo.ColaAtencionDTO;

@WebServlet(urlPatterns = {"/AtencionControlador"})
public class AtencionControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar encoding ANTES de obtener parámetros
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String acc = request.getParameter("acc");
        String accion = request.getParameter("accion");

        System.out.println("=== 🚀 ATENCIÓN CONTROLADOR INICIADO ===");
        System.out.println("📥 acc: '" + acc + "'");
        System.out.println("📥 accion: '" + accion + "'");

        try {
            // 1. Primero manejar el parámetro "acc" (para insertar/actualizar)
            if (acc != null && acc.equals("Confirmar")) {
                System.out.println("🎯 Ejecutando crearAtencionWalkIn");
                crearAtencionWalkIn(request, response);
                return;
            }

            // 2. Luego manejar el parámetro "accion" 
            if (accion != null) {
                System.out.println("🎯 Ejecutando acción específica: " + accion);
                switch (accion) {
                    case "colaActual":
                        obtenerColaActual(request, response);
                        return;
                    case "actualizarEstado":
                        actualizarEstadoAtencion(request, response);
                        return;
                    case "formularioWalkIn":
                        mostrarFormularioWalkIn(request, response);
                        return;
                    case "formularioEstado":
                        mostrarFormularioEstado(request, response);
                        return;
                    default:
                        System.out.println("❌ Acción no reconocida: " + accion);
                    // Caer al caso por defecto
                }
            }

            // 3. Caso por defecto (sin parámetros o acción no reconocida)
            System.out.println("🎯 Ejecutando caso por defecto: obtenerColaActual");
            obtenerColaActual(request, response);

        } catch (Exception e) {
            System.out.println("💥 ERROR en processRequest: " + e.getMessage());
            e.printStackTrace();
            try {
                request.setAttribute("mensaje", "❌ Error: " + e.getMessage());
                request.getRequestDispatcher("ColaAtencion.jsp").forward(request, response);
            } catch (Exception ex) {
                System.out.println("💥 ERROR en manejo de error: " + ex.getMessage());
            }
        }

        System.out.println("=== ✅ ATENCIÓN CONTROLADOR FINALIZADO ===");
    }

    // MÉTODO: Crear atención walk-in
    private void crearAtencionWalkIn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener y limpiar parámetros
            String idMascotaStr = limpiarParametro(request.getParameter("idMascota"));
            String idClienteStr = limpiarParametro(request.getParameter("idCliente"));
            String idGroomerStr = limpiarParametro(request.getParameter("idGroomer"));
            String idSucursalStr = limpiarParametro(request.getParameter("idSucursal"));
            String turnoNumStr = limpiarParametro(request.getParameter("turnoNum"));
            String tiempoEstimadoInicioStr = limpiarParametro(request.getParameter("tiempoEstimadoInicio"));
            String tiempoEstimadoFinStr = limpiarParametro(request.getParameter("tiempoEstimadoFin"));
            String prioridadStr = limpiarParametro(request.getParameter("prioridad"));
            String observaciones = limpiarParametro(request.getParameter("observaciones"));

            // Validaciones
            if (idMascotaStr == null || idMascotaStr.isEmpty()
                    || idClienteStr == null || idClienteStr.isEmpty()
                    || idGroomerStr == null || idGroomerStr.isEmpty()) {

                request.setAttribute("mensaje", "❌ Error: Mascota, Cliente y Groomer son obligatorios");
                request.getRequestDispatcher("CrearAtencionWalkIn.jsp").forward(request, response);
                return;
            }

            // Convertir IDs
            int idMascota, idCliente, idGroomer, idSucursal = 0, turnoNum = 0, prioridad = 0;
            try {
                idMascota = Integer.parseInt(idMascotaStr);
                idCliente = Integer.parseInt(idClienteStr);
                idGroomer = Integer.parseInt(idGroomerStr);

                if (idSucursalStr != null && !idSucursalStr.isEmpty()) {
                    idSucursal = Integer.parseInt(idSucursalStr);
                }
                if (turnoNumStr != null && !turnoNumStr.isEmpty()) {
                    turnoNum = Integer.parseInt(turnoNumStr);
                }
                if (prioridadStr != null && !prioridadStr.isEmpty()) {
                    prioridad = Integer.parseInt(prioridadStr);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ Error: Los IDs deben ser números válidos");
                request.getRequestDispatcher("CrearAtencionWalkIn.jsp").forward(request, response);
                return;
            }

            // Convertir timestamps
            Timestamp tiempoEstimadoInicio = null;
            Timestamp tiempoEstimadoFin = null;

            if (tiempoEstimadoInicioStr != null && !tiempoEstimadoInicioStr.isEmpty()) {
                try {
                    tiempoEstimadoInicio = Timestamp.valueOf(tiempoEstimadoInicioStr.replace("T", " ") + ":00");
                } catch (IllegalArgumentException e) {
                    request.setAttribute("mensaje", "❌ Error: Formato de fecha de inicio inválido");
                    request.getRequestDispatcher("CrearAtencionWalkIn.jsp").forward(request, response);
                    return;
                }
            }

            if (tiempoEstimadoFinStr != null && !tiempoEstimadoFinStr.isEmpty()) {
                try {
                    tiempoEstimadoFin = Timestamp.valueOf(tiempoEstimadoFinStr.replace("T", " ") + ":00");
                } catch (IllegalArgumentException e) {
                    request.setAttribute("mensaje", "❌ Error: Formato de fecha de fin inválido");
                    request.getRequestDispatcher("CrearAtencionWalkIn.jsp").forward(request, response);
                    return;
                }
            }

            // Crear atención
            Atencion atencion = new Atencion();
            atencion.setIdMascota(idMascota);
            atencion.setIdCliente(idCliente);
            atencion.setIdGroomer(idGroomer);
            atencion.setIdSucursal(idSucursal);
            atencion.setTurnoNum(turnoNum);
            atencion.setTiempoEstimadoInicio(tiempoEstimadoInicio);
            atencion.setTiempoEstimadoFin(tiempoEstimadoFin);
            atencion.setPrioridad(prioridad);
            atencion.setObservaciones(observaciones);

            // Insertar
            AtencionDao dao = new AtencionDao();
            boolean exito = dao.crearAtencionWalkIn(atencion);

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/AtencionControlador?accion=colaActual&creada=exito");
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al crear atención walk-in");
                request.getRequestDispatcher("CrearAtencionWalkIn.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error del sistema: " + e.getMessage());
            request.getRequestDispatcher("CrearAtencionWalkIn.jsp").forward(request, response);
            return;
        }
    }

    private void actualizarEstadoAtencion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== INICIANDO ACTUALIZACIÓN DE ESTADO ===");
        System.out.println("Parámetros recibidos:");
        System.out.println("idAtencion: " + request.getParameter("idAtencion"));
        System.out.println("nuevoEstado: " + request.getParameter("nuevoEstado"));
        System.out.println("accion: " + request.getParameter("accion"));

        try {
            String idAtencionStr = limpiarParametro(request.getParameter("idAtencion"));
            String nuevoEstado = limpiarParametro(request.getParameter("nuevoEstado"));

            System.out.println("Parámetros limpios:");
            System.out.println("idAtencion (limpio): " + idAtencionStr);
            System.out.println("nuevoEstado (limpio): " + nuevoEstado);

            if (idAtencionStr == null || idAtencionStr.isEmpty()
                    || nuevoEstado == null || nuevoEstado.isEmpty()) {

                System.out.println("❌ ERROR: Parámetros faltantes");
                request.setAttribute("mensaje", "❌ Error: ID Atención y Nuevo Estado son requeridos");
                obtenerColaActual(request, response); // CORREGIDO
                return;
            }

            int idAtencion = Integer.parseInt(idAtencionStr);

            // Validar estado
            List<String> estadosValidos = Arrays.asList("pendiente", "en_proceso", "completada", "cancelada");
            if (!estadosValidos.contains(nuevoEstado.toLowerCase())) {
                System.out.println("❌ ERROR: Estado inválido: " + nuevoEstado);
                request.setAttribute("mensaje", "❌ Error: Estado inválido. Use: pendiente, en_proceso, completada, cancelada");
                obtenerColaActual(request, response); // CORREGIDO
                return;
            }

            AtencionDao dao = new AtencionDao();
            System.out.println("📝 Ejecutando actualización en BD...");
            boolean exito = dao.actualizarEstadoAtencion(idAtencion, nuevoEstado);

            if (exito) {
                System.out.println("✅ Actualización exitosa");
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/AtencionControlador?accion=colaActual&estadoActualizado=exito&id=" + idAtencion);
                return;
            } else {
                System.out.println("❌ Error en la actualización BD");
                response.sendRedirect(request.getContextPath() + "/AtencionControlador?accion=colaActual&error=actualizar_estado");
                return;
            }

        } catch (NumberFormatException e) {
            System.out.println("❌ ERROR: NumberFormatException: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/AtencionControlador?accion=colaActual&error=id_invalido");
            return;
        } catch (Exception e) {
            System.out.println("❌ ERROR: Exception: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/AtencionControlador?accion=colaActual&error=sistema");
            return;
        }
    }

    // MÉTODO: Obtener cola actual de atenciones
    private void obtenerColaActual(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("=== OBTENIENDO COLA ACTUAL DE ATENCIONES ===");

            String idSucursalStr = limpiarParametro(request.getParameter("idSucursal"));

            Integer idSucursal = null;
            if (idSucursalStr != null && !idSucursalStr.isEmpty()) {
                try {
                    idSucursal = Integer.parseInt(idSucursalStr);
                } catch (NumberFormatException e) {
                    System.out.println("⚠️  ID Sucursal inválido, usando null");
                }
            }

            System.out.println("📋 ID Sucursal: " + (idSucursal != null ? idSucursal : "Todas las sucursales"));

            AtencionDao dao = new AtencionDao();
            List<ColaAtencionDTO> colaAtenciones = dao.obtenerColaActual(idSucursal);

            System.out.println("✅ Cola obtenida: " + (colaAtenciones != null ? colaAtenciones.size() : "null"));

            // Establecer atributos
            request.setAttribute("colaAtenciones", colaAtenciones);
            request.setAttribute("idSucursal", idSucursal);
            request.setAttribute("totalAtenciones", colaAtenciones != null ? colaAtenciones.size() : 0);

            // Debug: verificar que los atributos se establecieron
            System.out.println("📋 Atributos establecidos:");
            System.out.println("   - colaAtenciones: " + (request.getAttribute("colaAtenciones") != null));
            System.out.println("   - totalAtenciones: " + request.getAttribute("totalAtenciones"));

        } catch (Exception e) {
            System.out.println("❌ ERROR en obtenerColaActual: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensaje", "❌ Error al cargar cola de atenciones: " + e.getMessage());
        }

        request.getRequestDispatcher("ColaAtencion.jsp").forward(request, response);
    }

    // MÉTODO: Mostrar formulario para walk-in
    private void mostrarFormularioWalkIn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("CrearAtencionWalkIn.jsp").forward(request, response);
    }

    // MÉTODO: Mostrar formulario para actualizar estado
    private void mostrarFormularioEstado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("ActualizarEstadoAtencion.jsp").forward(request, response);
    }

    // Método auxiliar para limpiar parámetros
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
        return "Controlador para gestión completa de atenciones";
    }
}
