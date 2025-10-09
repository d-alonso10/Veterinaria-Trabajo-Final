package control;

import dao.UtilidadesDao;
import modelo.AuditLog;
import modelo.Notificacion;
import modelo.Factura;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UtilidadesControlador")
public class UtilidadesControlador extends HttpServlet {

    private UtilidadesDao utilidadesDao = new UtilidadesDao();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configurar encoding ANTES de obtener parámetros (FALTA EN TU CÓDIGO)
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");
        if (accion == null) accion = "panel";

        System.out.println("=== 🚀 UTILIDADES CONTROLADOR INICIADO ===");
        System.out.println("📥 accion: '" + accion + "'");

        try {
            switch (accion) {
                case "limpiar":
                    limpiarDatosTemporales(request, response);
                    break;
                case "backup":
                    generarBackupEsencial(request, response);
                    break;
                case "recalcular":
                    recalcularTotalesFacturas(request, response);
                    break;
                case "auditoria":
                    mostrarLogsAuditoria(request, response);
                    break;
                case "notificaciones":
                    mostrarNotificacionesPendientes(request, response);
                    break;
                case "facturasProblema":
                    mostrarFacturasConProblemas(request, response);
                    break;
                case "panel":
                default:
                    mostrarPanelUtilidades(request, response);
                    break;
            }
        } catch (Exception e) {
            System.out.println("💥 ERROR en processRequest: " + e.getMessage());
            e.printStackTrace();
            try {
                request.setAttribute("mensaje", "❌ Error del sistema: " + e.getMessage());
                request.getRequestDispatcher("UtilidadesPanel.jsp").forward(request, response);
            } catch (Exception ex) {
                System.out.println("💥 ERROR en manejo de error: " + ex.getMessage());
            }
        }

        System.out.println("=== ✅ UTILIDADES CONTROLADOR FINALIZADO ===");
    }

    // =========================================================
    // MÉTODOS DE ACCIÓN MEJORADOS
    // =========================================================

    private void mostrarPanelUtilidades(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("🎯 Mostrando panel de utilidades");
        RequestDispatcher dispatcher = request.getRequestDispatcher("UtilidadesPanel.jsp");
        dispatcher.forward(request, response);
    }

    private void limpiarDatosTemporales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("🎯 Ejecutando limpieza de datos temporales");

        try {
            // Obtener parámetro de días (más flexible)
            String diasParam = limpiarParametro(request.getParameter("dias"));
            int dias = (diasParam != null && !diasParam.isEmpty()) ? Integer.parseInt(diasParam) : 30;
            
            boolean exito = utilidadesDao.limpiarDatosTemporales(dias);

            if (exito) {
                request.setAttribute("mensaje", "✅ Limpieza completada correctamente (últimos " + dias + " días).");
                System.out.println("✅ Limpieza exitosa de últimos " + dias + " días");
            } else {
                request.setAttribute("mensaje", "❌ No se pudo realizar la limpieza de datos temporales.");
                System.out.println("❌ Error en limpieza de datos");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Error: El parámetro 'dias' debe ser un número válido");
            System.out.println("❌ Error de formato en parámetro días");
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error del sistema: " + e.getMessage());
            System.out.println("❌ Error general: " + e.getMessage());
        }

        mostrarPanelUtilidades(request, response);
    }

    private void generarBackupEsencial(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("🎯 Generando backup esencial");

        try {
            // Obtener fecha personalizada o usar fecha actual
            String fechaParam = limpiarParametro(request.getParameter("fecha"));
            Date fechaBackup;
            
            if (fechaParam != null && !fechaParam.isEmpty()) {
                fechaBackup = Date.valueOf(fechaParam);
            } else {
                fechaBackup = Date.valueOf(LocalDate.now());
            }

            boolean exito = utilidadesDao.generarBackupEsencial(fechaBackup);

            if (exito) {
                request.setAttribute("mensaje", "💾 Backup generado correctamente (" + fechaBackup + ").");
                System.out.println("✅ Backup exitoso para fecha: " + fechaBackup);
            } else {
                request.setAttribute("mensaje", "❌ Error al generar el backup esencial.");
                System.out.println("❌ Error generando backup");
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("mensaje", "❌ Error: Formato de fecha inválido. Use YYYY-MM-DD");
            System.out.println("❌ Formato de fecha inválido");
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error del sistema: " + e.getMessage());
            System.out.println("❌ Error general: " + e.getMessage());
        }

        mostrarPanelUtilidades(request, response);
    }

    private void recalcularTotalesFacturas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("🎯 Recalculando totales de facturas");

        try {
            boolean exito = utilidadesDao.recalcularTotalesFacturas();

            if (exito) {
                request.setAttribute("mensaje", "🧮 Recalculo de totales de facturas completado correctamente.");
                System.out.println("✅ Recalculo de facturas exitoso");
            } else {
                request.setAttribute("mensaje", "❌ Error al recalcular los totales de facturas.");
                System.out.println("❌ Error recalculando facturas");
            }

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error del sistema: " + e.getMessage());
            System.out.println("❌ Error general: " + e.getMessage());
        }

        mostrarPanelUtilidades(request, response);
    }

    private void mostrarLogsAuditoria(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("🎯 Mostrando logs de auditoría");

        try {
            // Obtener parámetro de días
            String diasParam = limpiarParametro(request.getParameter("dias"));
            int dias = (diasParam != null && !diasParam.isEmpty()) ? Integer.parseInt(diasParam) : 7;
            
            List<AuditLog> logs = utilidadesDao.obtenerLogsAuditoria(dias);

            request.setAttribute("logs", logs);
            request.setAttribute("diasConsulta", dias);
            request.setAttribute("totalLogs", logs != null ? logs.size() : 0);
            request.setAttribute("mensaje", "📋 Mostrando logs de auditoría de los últimos " + dias + " días.");
            
            System.out.println("✅ Logs obtenidos: " + (logs != null ? logs.size() : "null"));

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Error: El parámetro 'dias' debe ser un número válido");
            System.out.println("❌ Error de formato en parámetro días");
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar logs de auditoría: " + e.getMessage());
            System.out.println("❌ Error cargando logs: " + e.getMessage());
            // En caso de error, enviar lista vacía
            request.setAttribute("logs", new ArrayList<AuditLog>());
            request.setAttribute("totalLogs", 0);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("UtilidadesAuditoria.jsp");
        dispatcher.forward(request, response);
    }

    private void mostrarNotificacionesPendientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("🎯 Mostrando notificaciones pendientes");

        try {
            List<Notificacion> notificaciones = utilidadesDao.obtenerNotificacionesPendientes();

            request.setAttribute("notificaciones", notificaciones);
            request.setAttribute("totalNotificaciones", notificaciones != null ? notificaciones.size() : 0);
            
            if (notificaciones != null && !notificaciones.isEmpty()) {
                request.setAttribute("mensaje", "🔔 Mostrando notificaciones pendientes (" + notificaciones.size() + " encontradas).");
                System.out.println("✅ Notificaciones obtenidas: " + notificaciones.size());
            } else {
                request.setAttribute("mensaje", "✅ No hay notificaciones pendientes.");
                System.out.println("✅ No hay notificaciones pendientes");
            }

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar notificaciones: " + e.getMessage());
            System.out.println("❌ Error cargando notificaciones: " + e.getMessage());
            // En caso de error, enviar lista vacía
            request.setAttribute("notificaciones", new ArrayList<Notificacion>());
            request.setAttribute("totalNotificaciones", 0);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("UtilidadesNotificaciones.jsp");
        dispatcher.forward(request, response);
    }

    private void mostrarFacturasConProblemas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("🎯 Mostrando facturas con problemas");

        try {
            List<Factura> facturas = utilidadesDao.obtenerFacturasConProblemas();

            request.setAttribute("facturas", facturas);
            request.setAttribute("totalFacturas", facturas != null ? facturas.size() : 0);
            
            if (facturas != null && facturas.isEmpty()) {
                request.setAttribute("mensaje", "✅ No se encontraron facturas con problemas de cálculo.");
                System.out.println("✅ No hay facturas con problemas");
            } else {
                request.setAttribute("mensaje", "⚠️ Se detectaron " + facturas.size() + " facturas con inconsistencias.");
                System.out.println("✅ Facturas con problemas obtenidas: " + facturas.size());
            }

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar facturas con problemas: " + e.getMessage());
            System.out.println("❌ Error cargando facturas: " + e.getMessage());
            // En caso de error, enviar lista vacía
            request.setAttribute("facturas", new ArrayList<Factura>());
            request.setAttribute("totalFacturas", 0);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("UtilidadesFacturas.jsp");
        dispatcher.forward(request, response);
    }

    // Método auxiliar para limpiar parámetros (FALTABA EN TU CÓDIGO)
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
        return "Controlador para utilidades del sistema";
    }
}