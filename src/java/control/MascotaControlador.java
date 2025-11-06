package control;

import dao.MascotaDao;
import java.io.IOException;
import java.io.PrintWriter; // Importante para la respuesta JSON
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

// --- IMPORTACIONES PARA JSON (basado en json-20210307.jar) ---
import org.json.JSONArray;
import org.json.JSONObject;
// --- FIN IMPORTACIONES JSON ---

@WebServlet(urlPatterns = {"/MascotaControlador"})
public class MascotaControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        // El ContentType se setea en cada método (HTML o JSON)

        String acc = request.getParameter("acc");
        String accion = request.getParameter("accion");

        if (acc != null && acc.equals("Confirmar")) {
            response.setContentType("text/html;charset=UTF-8");
            insertarMascota(request, response);
        } 
        else if (accion != null) {
            switch (accion) {
                case "buscar":
                case "listarTodas":
                    response.setContentType("text/html;charset=UTF-8");
                    buscarMascotas(request, response);
                    break;
                case "obtenerPorCliente":
                    response.setContentType("text/html;charset=UTF-8");
                    obtenerMascotasPorCliente(request, response);
                    break;
                
                // --- CORRECCIÓN: ACCIÓN FALTANTE PARA AJAX ---
                case "obtenerMascotasJSON":
                    // Este método setea su propio ContentType a JSON
                    obtenerMascotasJSON(request, response);
                    break;
                // --- FIN CORRECCIÓN ---
                    
                case "historial":
                    response.setContentType("text/html;charset=UTF-8");
                    verHistorialMascota(request, response);
                    break;
                    
                case "mostrarFormulario":
                    response.setContentType("text/html;charset=UTF-8");
                    mostrarFormulario(request, response);
                    break;
                    
                default:
                    response.setContentType("text/html;charset=UTF-8");
                    mostrarFormulario(request, response); // Acción por defecto
            }
        } else {
            // Acción por defecto si no hay parámetros
            response.setContentType("text/html;charset=UTF-8");
            mostrarFormulario(request, response);
        }
    }

    // MÉTODO: Insertar mascota
    private void insertarMascota(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vistaError = "InsertarMascota.jsp";
        try {
            String idClienteStr = limpiarParametro(request.getParameter("idCliente"));
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String especie = limpiarParametro(request.getParameter("especie"));
            String raza = limpiarParametro(request.getParameter("raza"));
            String sexo = limpiarParametro(request.getParameter("sexo"));
            String fechaNacimiento = limpiarParametro(request.getParameter("fechaNacimiento"));
            String microchip = limpiarParametro(request.getParameter("microchip"));
            String observaciones = limpiarParametro(request.getParameter("observaciones"));

            if (idClienteStr.isEmpty() || nombre.isEmpty() || especie.isEmpty()) {
                request.setAttribute("mensaje", "❌ Error: ID Cliente, Nombre y Especie son obligatorios");
                request.setAttribute("tipoMensaje", "error");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            int idCliente;
            try {
                idCliente = Integer.parseInt(idClienteStr);
            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ Error: ID Cliente debe ser un número válido");
                request.setAttribute("tipoMensaje", "error");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            Mascota mascota = new Mascota();
            mascota.setIdCliente(idCliente);
            mascota.setNombre(nombre);
            mascota.setEspecie(especie);
            mascota.setRaza(raza);
            mascota.setSexo(sexo);

            if (fechaNacimiento != null && !fechaNacimiento.isEmpty()) {
                try {
                    java.sql.Date fechaNac = java.sql.Date.valueOf(fechaNacimiento);
                    mascota.setFechaNacimiento(fechaNac);
                } catch (IllegalArgumentException e) {
                    System.out.println("Fecha de nacimiento no válida: " + fechaNacimiento);
                }
            }

            mascota.setMicrochip(microchip);
            mascota.setObservaciones(observaciones);

            MascotaDao dao = new MascotaDao();
            boolean exito = dao.insertarMascota(mascota);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/MascotaControlador?accion=listarTodas&creado=exito");
            } else {
                request.setAttribute("mensaje", "❌ Error al insertar mascota");
                request.setAttribute("tipoMensaje", "error");
                request.getRequestDispatcher(vistaError).forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error del sistema: " + e.getMessage());
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher(vistaError).forward(request, response);
        }
    }

    
    // MÉTODO: Buscar mascotas (Unificado con ListarTodas)
    private void buscarMascotas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vista = "ListaMascotas.jsp";
        try {
            String creado = request.getParameter("creado");
            if ("exito".equals(creado)) {
                request.setAttribute("mensaje", "✅ Mascota creada exitosamente");
                request.setAttribute("tipoMensaje", "exito");
            }
            
            String termino = request.getParameter("termino");
            MascotaDao dao = new MascotaDao();
            List<MascotaBusquedaDTO> mascotas;

            if (termino == null || termino.trim().isEmpty()) {
                mascotas = dao.buscarMascotas("");
            } else {
                mascotas = dao.buscarMascotas(termino.trim());
                request.setAttribute("terminoBusqueda", termino);
            }

            request.setAttribute("mascotas", mascotas);
            request.setAttribute("totalResultados", mascotas != null ? mascotas.size() : 0);

        } catch (Exception e) {
            request.setAttribute("mascotas", new ArrayList<>()); 
            request.setAttribute("totalResultados", 0);
            request.setAttribute("mensaje", "❌ Error al buscar mascotas: " + e.getMessage());
            request.setAttribute("tipoMensaje", "error");
        }
        request.getRequestDispatcher(vista).forward(request, response);
    }

    // MÉTODO: Obtener mascotas por cliente (para página JSP dedicada)
    private void obtenerMascotasPorCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vista = "MascotasPorCliente.jsp";
        try {
            String idClienteStr = request.getParameter("idCliente");

            if (idClienteStr == null || idClienteStr.trim().isEmpty()) {
                request.setAttribute("mensaje", "❌ Error: ID Cliente es requerido");
                request.setAttribute("tipoMensaje", "error");
                request.getRequestDispatcher(vista).forward(request, response);
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
            request.setAttribute("tipoMensaje", "error");
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar mascotas del cliente: " + e.getMessage());
            request.setAttribute("tipoMensaje", "error");
        }
        request.getRequestDispatcher(vista).forward(request, response);
    }

    // --- NUEVO MÉTODO PARA AJAX (JSON) ---
    /**
     * Devuelve las mascotas de un cliente en formato JSON para AJAX.
     * Usa la librería org.json (json-20210307.jar).
     */
    private void obtenerMascotasJSON(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String idClienteStr = limpiarParametro(request.getParameter("idCliente"));
            if (idClienteStr.isEmpty()) {
                throw new NumberFormatException("ID de cliente vacío");
            }
            
            int idCliente = Integer.parseInt(idClienteStr);
            
            MascotaDao dao = new MascotaDao();
            // ¡Importante! Usamos el DAO refactorizado
            List<Mascota> mascotas = dao.obtenerMascotasPorCliente(idCliente); 

            // Convertir la Lista a un JSONArray usando org.json
            JSONArray jsonArray = new JSONArray();
            if (mascotas != null) {
                for (Mascota mascota : mascotas) {
                    JSONObject jsonMascota = new JSONObject();
                    jsonMascota.put("idMascota", mascota.getIdMascota());
                    jsonMascota.put("nombre", mascota.getNombre());
                    jsonMascota.put("especie", mascota.getEspecie());
                    jsonArray.put(jsonMascota);
                }
            }
            
            out.print(jsonArray.toString());

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
            out.print("{\"error\":\"ID de cliente inválido: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
            out.print("{\"error\":\"Error del servidor: " + e.getMessage() + "\"}");
            e.printStackTrace();
        } finally {
            out.flush();
        }
    }
    // --- FIN NUEVO MÉTODO ---

    // MÉTODO: Ver historial de mascota
    private void verHistorialMascota(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vista = "HistorialMascota.jsp";
        try {
            String idMascotaStr = request.getParameter("idMascota");

            if (idMascotaStr == null || idMascotaStr.trim().isEmpty()) {
                request.setAttribute("mensaje", "❌ Error: ID Mascota es requerido");
                request.setAttribute("tipoMensaje", "error");
                request.getRequestDispatcher(vista).forward(request, response);
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
            request.setAttribute("tipoMensaje", "error");
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar historial de la mascota: " + e.getMessage());
            request.setAttribute("tipoMensaje", "error");
        }
        request.getRequestDispatcher(vista).forward(request, response);
    }
    
    // --- NUEVO MÉTODO PARA MOSTRAR FORMULARIO ---
    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("InsertarMascota.jsp").forward(request, response);
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
        return "Controlador para gestión completa de mascotas";
    }
}