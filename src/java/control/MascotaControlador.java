package control;

import dao.MascotaDao;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Mascota;
import modelo.HistorialMascotaDTO;
import modelo.MascotaBusquedaDTO;

@WebServlet(urlPatterns = {"/MascotaControlador"})
public class MascotaControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar encoding ANTES de obtener parámetros
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String acc = request.getParameter("acc");
        String accion = request.getParameter("accion");

        // Manejar inserción con parámetro "acc"
        if (acc != null && acc.equals("Confirmar")) {
            insertarMascota(request, response);
        } // Manejar otras acciones con el parámetro "accion"
        else if (accion != null) {
            switch (accion) {
                case "buscar":
                case "listarTodas": // <-- CORRECCIÓN: Ambas acciones usan el mismo método
                    buscarMascotas(request, response);
                    break;
                case "obtenerPorCliente":
                    obtenerMascotasPorCliente(request, response);
                    break;
                case "historial":
                    verHistorialMascota(request, response);
                    break;
                default:
                    // Redirigir a un JSP de formulario si la acción no es reconocida
                    // o si se llama al controlador sin acción.
                    request.getRequestDispatcher("InsertarMascota.jsp").forward(request, response);
            }
        } else {
            // Acción por defecto: mostrar el formulario de inserción
            request.getRequestDispatcher("InsertarMascota.jsp").forward(request, response);
        }
    }

    // MÉTODO: Insertar mascota
    private void insertarMascota(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener y limpiar parámetros
            String idClienteStr = limpiarParametro(request.getParameter("idCliente"));
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String especie = limpiarParametro(request.getParameter("especie"));
            String raza = limpiarParametro(request.getParameter("raza"));
            String sexo = limpiarParametro(request.getParameter("sexo"));
            String fechaNacimiento = limpiarParametro(request.getParameter("fechaNacimiento"));
            String microchip = limpiarParametro(request.getParameter("microchip"));
            String observaciones = limpiarParametro(request.getParameter("observaciones"));

            // Validaciones
            if (idClienteStr == null || idClienteStr.isEmpty()
                    || nombre == null || nombre.isEmpty()
                    || especie == null || especie.isEmpty()) {

                request.setAttribute("mensaje", "❌ Error: ID Cliente, Nombre y Especie son obligatorios");
                request.getRequestDispatcher("InsertarMascota.jsp").forward(request, response);
                return;
            }

            // Convertir ID Cliente
            int idCliente;
            try {
                idCliente = Integer.parseInt(idClienteStr);
            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ Error: ID Cliente debe ser un número válido");
                request.getRequestDispatcher("InsertarMascota.jsp").forward(request, response);
                return;
            }

            // Crear mascota
            Mascota mascota = new Mascota();
            mascota.setIdCliente(idCliente);
            mascota.setNombre(nombre);
            mascota.setEspecie(especie);
            mascota.setRaza(raza);
            mascota.setSexo(sexo);

            // Convertir fecha si está presente
            if (fechaNacimiento != null && !fechaNacimiento.isEmpty()) {
                try {
                    java.sql.Date fechaNac = java.sql.Date.valueOf(fechaNacimiento);
                    mascota.setFechaNacimiento(fechaNac);
                } catch (IllegalArgumentException e) {
                    // Si la fecha no es válida, se deja como null
                    System.out.println("Fecha de nacimiento no válida: " + fechaNacimiento);
                }
            }

            mascota.setMicrochip(microchip);
            mascota.setObservaciones(observaciones);

            // Insertar
            MascotaDao dao = new MascotaDao();
            boolean exito = dao.insertarMascota(mascota);

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                // Redirigimos a la acción 'listarTodas' y añadimos el parámetro 'creado=exito'
                response.sendRedirect(request.getContextPath() + "/MascotaControlador?accion=listarTodas&creado=exito");
                return; // Importante hacer return después de un sendRedirect
            } else {
                request.setAttribute("mensaje", "❌ Error al insertar mascota");
            }

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error del sistema: " + e.getMessage());
        }

        // Solo usar forward en caso de error para mostrar el mensaje en el formulario
        request.getRequestDispatcher("InsertarMascota.jsp").forward(request, response);
    }

    
    // MÉTODO: Buscar mascotas (Unificado con ListarTodas)
    private void buscarMascotas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Verificar si viene de una creación exitosa
            String creado = request.getParameter("creado");
            if ("exito".equals(creado)) {
                request.setAttribute("mensaje", "✅ Mascota creada exitosamente");
                request.setAttribute("tipoMensaje", "exito");
            }
            
            String termino = request.getParameter("termino");

            MascotaDao dao = new MascotaDao();
            List<MascotaBusquedaDTO> mascotas;

            if (termino == null || termino.trim().isEmpty()) {
                // Si no hay término, cargar todas las mascotas
                mascotas = dao.buscarMascotas("");
            } else {
                // Si hay término, buscar
                mascotas = dao.buscarMascotas(termino.trim());
                request.setAttribute("terminoBusqueda", termino);
            }

            request.setAttribute("mascotas", mascotas);
            request.setAttribute("totalResultados", mascotas != null ? mascotas.size() : 0);

        } catch (Exception e) {
            request.setAttribute("mascotas", new ArrayList<>()); // Enviar lista vacía en error
            request.setAttribute("totalResultados", 0);
            request.setAttribute("mensaje", "❌ Error al buscar mascotas: " + e.getMessage());
        }

        // Redirigir al JSP que muestra la tabla completa
        request.getRequestDispatcher("ListaMascotas.jsp").forward(request, response);
    }

    // MÉTODO: Obtener mascotas por cliente
    private void obtenerMascotasPorCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idClienteStr = request.getParameter("idCliente");

            if (idClienteStr == null || idClienteStr.trim().isEmpty()) {
                request.setAttribute("mensaje", "❌ Error: ID Cliente es requerido");
                request.getRequestDispatcher("MascotasPorCliente.jsp").forward(request, response);
                return;
            }

            int idCliente = Integer.parseInt(idClienteStr.trim());
            MascotaDao dao = new MascotaDao();
            List<Mascota> mascotas = dao.obtenerMascotasPorCliente(idCliente);

            request.setAttribute("mascotas", mascotas);
            request.setAttribute("idCliente", idCliente);
            request.setAttribute("totalMascotas", mascotas.size());

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Error: ID Cliente debe ser un número válido");
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar mascotas del cliente: " + e.getMessage());
        }

        request.getRequestDispatcher("MascotasPorCliente.jsp").forward(request, response);
    }

    // MÉTODO: Ver historial de mascota
    private void verHistorialMascota(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idMascotaStr = request.getParameter("idMascota");

            if (idMascotaStr == null || idMascotaStr.trim().isEmpty()) {
                request.setAttribute("mensaje", "❌ Error: ID Mascota es requerido");
                request.getRequestDispatcher("HistorialMascota.jsp").forward(request, response);
                return;
            }

            int idMascota = Integer.parseInt(idMascotaStr.trim());
            MascotaDao dao = new MascotaDao();
            List<HistorialMascotaDTO> historial = dao.historialMascota(idMascota);

            request.setAttribute("historial", historial);
            request.setAttribute("idMascota", idMascota);
            request.setAttribute("totalAtenciones", historial.size());

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Error: ID Mascota debe ser un número válido");
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar historial de la mascota: " + e.getMessage());
        }

        request.getRequestDispatcher("HistorialMascota.jsp").forward(request, response);
    }

    
    // --- MÉTODO listarTodasMascotas() ELIMINADO ---
    // La lógica se ha fusionado con buscarMascotas()

    
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
        return "Controlador para gestión completa de mascotas";
    }
}