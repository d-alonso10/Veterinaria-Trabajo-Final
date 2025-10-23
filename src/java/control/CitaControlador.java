package control;

import dao.CitaDao;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Cita;
import modelo.CitaProximaDTO;

@WebServlet(urlPatterns = {"/CitaControlador"})
public class CitaControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar encoding ANTES de obtener parámetros
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String acc = request.getParameter("acc");
        String accion = request.getParameter("accion");

        System.out.println("=== 🚀 PROCESS REQUEST INICIADO ===");
        System.out.println("📥 acc: '" + acc + "'");
        System.out.println("📥 accion: '" + accion + "'");

        try {
            // 1. Primero manejar el parámetro "acc" (para insertar)
            if (acc != null && acc.equals("Confirmar")) {
                System.out.println("🎯 Ejecutando crearCita");
                crearCita(request, response);
                return;
            }

            // 2. Luego manejar el parámetro "accion" 
            if (accion != null) {
                System.out.println("🎯 Ejecutando acción específica: " + accion);
                switch (accion) {
                    case "reprogramar":
                        reprogramarCita(request, response);
                        return;
                    case "cancelar":
                        cancelarCita(request, response);
                        return;
                    case "confirmarAsistencia":
                        confirmarAsistenciaCita(request, response);
                        return;
                    case "proximasCitas":
                        obtenerProximasCitas(request, response);
                        return;
                    case "todasCitas":
                        obtenerTodasCitas(request, response);
                        return;
                    case "crearAtencion":
                        crearAtencionDesdeCita(request, response);
                        return;
                    case "emergencia":
                        forzarCitas(request, response);
                        return;
                    default:
                        System.out.println("❌ Acción no reconocida: " + accion);
                    // Caer al caso por defecto
                }
            }

            // 3. Caso por defecto (sin parámetros o acción no reconocida)
            System.out.println("🎯 Ejecutando caso por defecto: obtenerTodasCitas");
            obtenerTodasCitas(request, response);

        } catch (Exception e) {
            System.out.println("💥 ERROR en processRequest: " + e.getMessage());
            e.printStackTrace();
            try {
                request.setAttribute("mensaje", "❌ Error: " + e.getMessage());
                request.getRequestDispatcher("ProximasCitas.jsp").forward(request, response);
            } catch (Exception ex) {
                System.out.println("💥 ERROR en manejo de error: " + ex.getMessage());
            }
        }

        System.out.println("=== ✅ PROCESS REQUEST FINALIZADO ===");
    }

// En el CitaControlador, agrega este método de emergencia:
    private void forzarCitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("=== MÉTODO DE EMERGENCIA ===");

            // Crear una cita de prueba manualmente
            CitaProximaDTO citaPrueba = new CitaProximaDTO();
            citaPrueba.setIdCita(999);
            citaPrueba.setFechaProgramada(new java.sql.Timestamp(System.currentTimeMillis()));
            citaPrueba.setMascota("Mascota de Prueba");
            citaPrueba.setServicio("Servicio de Prueba");
            citaPrueba.setEstado("reservada");
            citaPrueba.setModalidad("presencial");

            List<CitaProximaDTO> citas = new ArrayList<>();
            citas.add(citaPrueba);

            request.setAttribute("proximasCitas", citas);
            request.setAttribute("totalCitas", 1);
            request.setAttribute("mensaje", "✅ Método de emergencia - Datos de prueba");

            System.out.println("✅ Datos de prueba creados");

        } catch (Exception e) {
            System.out.println("❌ ERROR en forzarCitas: " + e.getMessage());
        }

        request.getRequestDispatcher("ProximasCitas.jsp").forward(request, response);
    }

    // MÉTODO: Crear cita
    private void crearCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener y limpiar parámetros
            String idMascotaStr = limpiarParametro(request.getParameter("idMascota"));
            String idClienteStr = limpiarParametro(request.getParameter("idCliente"));
            String idSucursalStr = limpiarParametro(request.getParameter("idSucursal"));
            String idServicioStr = limpiarParametro(request.getParameter("idServicio"));
            String fechaProgramadaStr = limpiarParametro(request.getParameter("fechaProgramada"));
            String modalidad = limpiarParametro(request.getParameter("modalidad"));
            String notas = limpiarParametro(request.getParameter("notas"));

            // Validaciones
            if (idMascotaStr == null || idMascotaStr.isEmpty()
                    || idClienteStr == null || idClienteStr.isEmpty()
                    || fechaProgramadaStr == null || fechaProgramadaStr.isEmpty()) {

                request.setAttribute("mensaje", "❌ Error: Mascota, Cliente y Fecha son obligatorios");
                request.getRequestDispatcher("CrearCita.jsp").forward(request, response);
                return;
            }

            // Convertir IDs
            int idMascota, idCliente, idSucursal = 0, idServicio = 0;
            try {
                idMascota = Integer.parseInt(idMascotaStr);
                idCliente = Integer.parseInt(idClienteStr);
                if (idSucursalStr != null && !idSucursalStr.isEmpty()) {
                    idSucursal = Integer.parseInt(idSucursalStr);
                }
                if (idServicioStr != null && !idServicioStr.isEmpty()) {
                    idServicio = Integer.parseInt(idServicioStr);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ Error: Los IDs deben ser números válidos");
                request.getRequestDispatcher("CrearCita.jsp").forward(request, response);
                return;
            }

            // Convertir fecha
            Timestamp fechaProgramada;
            try {
                fechaProgramada = Timestamp.valueOf(fechaProgramadaStr.replace("T", " ") + ":00");
            } catch (IllegalArgumentException e) {
                request.setAttribute("mensaje", "❌ Error: Formato de fecha inválido");
                request.getRequestDispatcher("CrearCita.jsp").forward(request, response);
                return;
            }

            // Crear cita
            Cita cita = new Cita();
            cita.setIdMascota(idMascota);
            cita.setIdCliente(idCliente);
            cita.setIdSucursal(idSucursal);
            cita.setIdServicio(idServicio);
            cita.setFechaProgramada(fechaProgramada);
            cita.setModalidad(modalidad != null && !modalidad.isEmpty() ? modalidad : "presencial");
            cita.setNotas(notas);

            // Insertar
            CitaDao dao = new CitaDao();
            boolean exito = dao.crearCita(cita);

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/CitaControlador?accion=todasCitas&creada=exito");
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al crear cita");
                request.getRequestDispatcher("CrearCita.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error del sistema: " + e.getMessage());
            request.getRequestDispatcher("CrearCita.jsp").forward(request, response);
            return;
        }
    }

    // MÉTODO: Reprogramar cita
    private void reprogramarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idCitaStr = limpiarParametro(request.getParameter("idCita"));
            String nuevaFechaStr = limpiarParametro(request.getParameter("nuevaFecha"));

            if (idCitaStr == null || idCitaStr.isEmpty()
                    || nuevaFechaStr == null || nuevaFechaStr.isEmpty()) {

                request.setAttribute("mensaje", "❌ Error: ID Cita y Nueva Fecha son requeridos");
                request.getRequestDispatcher("ReprogramarCita.jsp").forward(request, response);
                return;
            }

            int idCita = Integer.parseInt(idCitaStr);
            Timestamp nuevaFecha = Timestamp.valueOf(nuevaFechaStr.replace("T", " ") + ":00");

            CitaDao dao = new CitaDao();
            boolean exito = dao.reprogramarCita(idCita, nuevaFecha);

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/CitaControlador?accion=todasCitas&reprogramada=exito&id=" + idCita);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al reprogramar cita");
                request.getRequestDispatcher("ReprogramarCita.jsp").forward(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Error: ID Cita debe ser un número válido");
            request.getRequestDispatcher("ReprogramarCita.jsp").forward(request, response);
            return;
        } catch (IllegalArgumentException e) {
            request.setAttribute("mensaje", "❌ Error: Formato de fecha inválido");
            request.getRequestDispatcher("ReprogramarCita.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al reprogramar cita: " + e.getMessage());
            request.getRequestDispatcher("ReprogramarCita.jsp").forward(request, response);
            return;
        }
    }

    // MÉTODO: Cancelar cita
    private void cancelarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idCitaStr = limpiarParametro(request.getParameter("idCita"));

            if (idCitaStr == null || idCitaStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Error: ID Cita es requerido");
                request.getRequestDispatcher("CancelarCita.jsp").forward(request, response);
                return;
            }

            int idCita = Integer.parseInt(idCitaStr);
            CitaDao dao = new CitaDao();
            boolean exito = dao.cancelarCita(idCita);

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/CitaControlador?accion=todasCitas&cancelada=exito&id=" + idCita);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al cancelar cita");
                request.getRequestDispatcher("CancelarCita.jsp").forward(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Error: ID Cita debe ser un número válido");
            request.getRequestDispatcher("CancelarCita.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cancelar cita: " + e.getMessage());
            request.getRequestDispatcher("CancelarCita.jsp").forward(request, response);
            return;
        }
    }

    // MÉTODO: Confirmar asistencia a cita
    private void confirmarAsistenciaCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idCitaStr = limpiarParametro(request.getParameter("idCita"));

            if (idCitaStr == null || idCitaStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Error: ID Cita es requerido");
                request.getRequestDispatcher("ConfirmarAsistencia.jsp").forward(request, response);
                return;
            }

            int idCita = Integer.parseInt(idCitaStr);
            CitaDao dao = new CitaDao();
            boolean exito = dao.confirmarAsistenciaCita(idCita);

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/CitaControlador?accion=todasCitas&confirmada=exito&id=" + idCita);
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/CitaControlador?accion=todasCitas&error=confirmar_asistencia");
                return;
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/CitaControlador?accion=todasCitas&error=id_invalido");
            return;
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/CitaControlador?accion=todasCitas&error=sistema");
            return;
        }
    }

    // MÉTODO: Obtener próximas citas de un cliente
    private void obtenerProximasCitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idClienteStr = limpiarParametro(request.getParameter("idCliente"));

            if (idClienteStr == null || idClienteStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Error: ID Cliente es requerido");
                request.getRequestDispatcher("ProximasCitas.jsp").forward(request, response);
                return;
            }

            int idCliente = Integer.parseInt(idClienteStr);
            CitaDao dao = new CitaDao();
            List<CitaProximaDTO> proximasCitas = dao.obtenerProximasCitas(idCliente);

            request.setAttribute("proximasCitas", proximasCitas);
            request.setAttribute("idCliente", idCliente);
            request.setAttribute("totalCitas", proximasCitas.size());

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Error: ID Cliente debe ser un número válido");
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar próximas citas: " + e.getMessage());
        }

        request.getRequestDispatcher("ProximasCitas.jsp").forward(request, response);
    }

    private void obtenerTodasCitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("=== OBTENIENDO TODAS LAS CITAS ===");
            System.out.println("📥 Request URL: " + request.getRequestURL());
            System.out.println("📥 Query String: " + request.getQueryString());

            CitaDao dao = new CitaDao();
            List<CitaProximaDTO> todasCitas = dao.obtenerTodasProximasCitas();

            System.out.println("✅ Citas obtenidas del Dao: " + (todasCitas != null ? todasCitas.size() : "null"));

            // Establecer atributos
            request.setAttribute("proximasCitas", todasCitas);
            request.setAttribute("totalCitas", todasCitas != null ? todasCitas.size() : 0);

            // Debug: verificar que los atributos se establecieron
            System.out.println("📋 Atributos establecidos:");
            System.out.println("   - proximasCitas: " + (request.getAttribute("proximasCitas") != null));
            System.out.println("   - totalCitas: " + request.getAttribute("totalCitas"));

            String dispatcherPath = "ProximasCitas.jsp";
            System.out.println("📤 Forward a: " + dispatcherPath);

            RequestDispatcher dispatcher = request.getRequestDispatcher(dispatcherPath);
            System.out.println("🔧 Dispatcher obtenido: " + (dispatcher != null));

            dispatcher.forward(request, response);

            System.out.println("✅ Forward completado");

        } catch (Exception e) {
            System.out.println("❌ ERROR en obtenerTodasCitas: " + e.getMessage());
            e.printStackTrace();

            // Intentar redirigir de todas formas
            try {
                request.getRequestDispatcher("ProximasCitas.jsp").forward(request, response);
            } catch (Exception ex) {
                System.out.println("❌ ERROR en redirección de fallback: " + ex.getMessage());
            }
        }
    }

    // MÉTODO: Crear atención desde cita
    private void crearAtencionDesdeCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idCitaStr = limpiarParametro(request.getParameter("idCita"));
            String idGroomerStr = limpiarParametro(request.getParameter("idGroomer"));
            String idSucursalStr = limpiarParametro(request.getParameter("idSucursal"));
            String turnoNumStr = limpiarParametro(request.getParameter("turnoNum"));
            String tiempoEstimadoInicioStr = limpiarParametro(request.getParameter("tiempoEstimadoInicio"));
            String tiempoEstimadoFinStr = limpiarParametro(request.getParameter("tiempoEstimadoFin"));
            String prioridadStr = limpiarParametro(request.getParameter("prioridad"));

            // Validaciones
            if (idCitaStr == null || idCitaStr.isEmpty()
                    || idGroomerStr == null || idGroomerStr.isEmpty()) {

                request.setAttribute("mensaje", "❌ Error: ID Cita y ID Groomer son obligatorios");
                request.getRequestDispatcher("CrearAtencionDesdeCita.jsp").forward(request, response);
                return;
            }

            // Convertir parámetros
            int idCita = Integer.parseInt(idCitaStr);
            int idGroomer = Integer.parseInt(idGroomerStr);
            int idSucursal = idSucursalStr != null && !idSucursalStr.isEmpty() ? Integer.parseInt(idSucursalStr) : 0;
            int turnoNum = turnoNumStr != null && !turnoNumStr.isEmpty() ? Integer.parseInt(turnoNumStr) : 0;
            int prioridad = prioridadStr != null && !prioridadStr.isEmpty() ? Integer.parseInt(prioridadStr) : 0;

            // Convertir timestamps
            Timestamp tiempoEstimadoInicio = null;
            Timestamp tiempoEstimadoFin = null;

            if (tiempoEstimadoInicioStr != null && !tiempoEstimadoInicioStr.isEmpty()) {
                tiempoEstimadoInicio = Timestamp.valueOf(tiempoEstimadoInicioStr.replace("T", " ") + ":00");
            }
            if (tiempoEstimadoFinStr != null && !tiempoEstimadoFinStr.isEmpty()) {
                tiempoEstimadoFin = Timestamp.valueOf(tiempoEstimadoFinStr.replace("T", " ") + ":00");
            }

            CitaDao dao = new CitaDao();
            boolean exito = dao.crearAtencionDesdeCita(idCita, idGroomer, idSucursal,
                    turnoNum, tiempoEstimadoInicio, tiempoEstimadoFin, prioridad);

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/AtencionControlador?accion=colaActual&creadaDesdeCita=exito&idCita=" + idCita);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al crear atención desde cita");
                request.getRequestDispatcher("CrearAtencionDesdeCita.jsp").forward(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Error: Los IDs y números deben ser válidos");
            request.getRequestDispatcher("CrearAtencionDesdeCita.jsp").forward(request, response);
            return;
        } catch (IllegalArgumentException e) {
            request.setAttribute("mensaje", "❌ Error: Formato de fecha inválido");
            request.getRequestDispatcher("CrearAtencionDesdeCita.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al crear atención desde cita: " + e.getMessage());
            request.getRequestDispatcher("CrearAtencionDesdeCita.jsp").forward(request, response);
            return;
        }
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
        return "Controlador para gestión completa de citas";
    }
}
