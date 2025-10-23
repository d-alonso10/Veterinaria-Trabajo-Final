package control;

import dao.GroomerDao;
import java.io.IOException;
import java.sql.Date;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Groomer;
import modelo.TiempoPromedioGroomerDTO;
import modelo.OcupacionGroomerDTO;
import modelo.GroomerDisponibilidadDTO;

@WebServlet(urlPatterns = {"/GroomerControlador"})
public class GroomerControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar encoding ANTES de obtener parámetros
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String acc = request.getParameter("acc");
        String accion = request.getParameter("accion");

        System.out.println("=== 🚀 GROOMER CONTROLADOR INICIADO ===");
        System.out.println("📥 acc: '" + acc + "'");
        System.out.println("📥 accion: '" + accion + "'");

        try {
            // Manejar el parámetro "acc" (para insertar/actualizar)
            if (acc != null) {
                switch (acc) {
                    case "Confirmar":
                        System.out.println("🎯 Ejecutando insertarGroomer");
                        insertarGroomer(request, response);
                        return;
                    case "Actualizar":
                        System.out.println("🎯 Ejecutando actualizarGroomer");
                        actualizarGroomer(request, response);
                        return;
                    default:
                        System.out.println("❌ Acción 'acc' no reconocida: " + acc);
                }
            }

            // Manejar el parámetro "accion" para otras operaciones
            if (accion != null) {
                System.out.println("🎯 Ejecutando acción específica: " + accion);
                switch (accion) {
                    case "listar":
                        listarGroomers(request, response);
                        break;
                    case "tiemposPromedio":
                        obtenerTiemposPromedio(request, response);
                        break;
                    case "ocupacion":
                        obtenerOcupacion(request, response);
                        break;
                    case "disponibilidad":
                        obtenerDisponibilidad(request, response);
                        break;
                    case "formularioInsertar":
                        mostrarFormularioInsertar(request, response);
                        break;
                    case "formularioActualizar":
                        mostrarFormularioActualizar(request, response);
                        break;
                    default:
                        System.out.println("❌ Acción no reconocida: " + accion);
                        // Redirigir al listado por defecto
                        listarGroomers(request, response);
                }
            } else {
                // Caso por defecto: listar groomers
                System.out.println("🎯 Ejecutando caso por defecto: listarGroomers");
                listarGroomers(request, response);
            }

        } catch (Exception e) {
            System.out.println("💥 ERROR en processRequest: " + e.getMessage());
            e.printStackTrace();
            try {
                request.setAttribute("mensaje", "❌ Error del sistema: " + e.getMessage());
                request.getRequestDispatcher("ListaGroomers.jsp").forward(request, response);
            } catch (Exception ex) {
                System.out.println("💥 ERROR en manejo de error: " + ex.getMessage());
            }
        }

        System.out.println("=== ✅ GROOMER CONTROLADOR FINALIZADO ===");
    }

    // MÉTODO: Insertar groomer
    private void insertarGroomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener y limpiar parámetros
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String especialidadesJson = limpiarParametro(request.getParameter("especialidades"));
            String disponibilidadJson = limpiarParametro(request.getParameter("disponibilidad"));

            // Validaciones
            if (nombre == null || nombre.isEmpty()) {
                request.setAttribute("mensaje", "❌ Error: El nombre del groomer es obligatorio");
                request.getRequestDispatcher("InsertarGroomer.jsp").forward(request, response);
                return;
            }

            // Validar que los JSON sean válidos
            if (!esValidoJSONArray(especialidadesJson)) {
                especialidadesJson = "[]"; // JSON array vacío por defecto
            }

            if (!esValidoJSONObject(disponibilidadJson)) {
                disponibilidadJson = "{}"; // JSON object vacío por defecto
            }

            // Crear groomer
            Groomer groomer = new Groomer();
            groomer.setNombre(nombre);
            groomer.setEspecialidades(especialidadesJson);
            groomer.setDisponibilidad(disponibilidadJson);

            // Insertar
            GroomerDao dao = new GroomerDao();
            int idGenerado = dao.insertarGroomer(groomer);

            if (idGenerado > 0) {
                // ✅ PRG PATTERN: Redirigir después de POST exitoso
                response.sendRedirect(request.getContextPath() + "/GroomerControlador?accion=listar&creado=exito&id=" + idGenerado);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al insertar groomer");
                request.getRequestDispatcher("/InsertarGroomer.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error del sistema: " + e.getMessage());
            request.getRequestDispatcher("/InsertarGroomer.jsp").forward(request, response);
            return;
        }
    }

    private void actualizarGroomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener parámetros
            String idGroomerStr = request.getParameter("idGroomer");
            String nombre = request.getParameter("nombre");

            // Obtener especialidades y disponibilidad directamente de los hidden fields
            String especialidadesJson = request.getParameter("especialidades");
            String disponibilidadJson = request.getParameter("disponibilidad");

            System.out.println("=== DATOS RECIBIDOS ===");
            System.out.println("idGroomer: " + idGroomerStr);
            System.out.println("nombre: " + nombre);
            System.out.println("especialidades: " + especialidadesJson);
            System.out.println("disponibilidad: " + disponibilidadJson);

            // Validaciones básicas
            if (idGroomerStr == null || idGroomerStr.isEmpty() || nombre == null || nombre.isEmpty()) {
                request.setAttribute("mensaje", "❌ Error: ID y nombre son obligatorios");
                request.getRequestDispatcher("ActualizarGroomer.jsp").forward(request, response);
                return;
            }

            int idGroomer = Integer.parseInt(idGroomerStr);

            // Usar valores por defecto si vienen vacíos
            if (especialidadesJson == null || especialidadesJson.isEmpty()) {
                especialidadesJson = "[]";
            }
            if (disponibilidadJson == null || disponibilidadJson.isEmpty()) {
                disponibilidadJson = "{}";
            }

            // Crear y actualizar groomer
            Groomer groomer = new Groomer();
            groomer.setIdGroomer(idGroomer);
            groomer.setNombre(nombre);
            groomer.setEspecialidades(especialidadesJson);
            groomer.setDisponibilidad(disponibilidadJson);

            GroomerDao dao = new GroomerDao();
            boolean exito = dao.actualizarGroomer(groomer);

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/GroomerControlador?accion=listar&actualizado=exito&id=" + idGroomer);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al actualizar groomer");
                request.getRequestDispatcher("ActualizarGroomer.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            System.out.println("❌ Error: " + e.getMessage());
            request.setAttribute("mensaje", "❌ Error: " + e.getMessage());
            request.getRequestDispatcher("ActualizarGroomer.jsp").forward(request, response);
            return;
        }
    }

// MÉTODO: Listar todos los groomers
    private void listarGroomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Verificar si viene de una creación exitosa
            String creado = request.getParameter("creado");
            String id = request.getParameter("id");
            if ("exito".equals(creado)) {
                String groomerInfo = (id != null) ? " (ID: " + id + ")" : "";
                request.setAttribute("mensaje", "✅ Groomer creado exitosamente" + groomerInfo);
                request.setAttribute("tipoMensaje", "exito");
            }

            System.out.println("=== OBTENIENDO TODOS LOS GROOMERS ===");

            GroomerDao dao = new GroomerDao();
            List<Groomer> groomers = dao.obtenerGroomers();

            System.out.println("✅ Groomers obtenidos: " + (groomers != null ? groomers.size() : "null"));

            // Procesar JSON para mostrar de forma legible Y corregir encoding
            if (groomers != null) {
                for (Groomer groomer : groomers) {
                    // CORRECCIÓN DE CARACTERES ESPECIALES - Agregado aquí
                    // Corregir caracteres especiales en el nombre
                    if (groomer.getNombre() != null) {
                        String nombre = groomer.getNombre();
                        // Reemplazar caracteres corruptos
                        nombre = nombre.replace("√°", "á")
                                .replace("√©", "é")
                                .replace("√≠", "í")
                                .replace("√≥", "ó")
                                .replace("√ļ", "ú")
                                .replace("√Ī", "ñ")
                                .replace("√ģ", "Ñ")
                                .replace("√Ē", "í")
                                .replace("‚ąöń™", "ñ");
                        groomer.setNombre(nombre);
                    }

                    // Corregir caracteres en especialidades
                    if (groomer.getEspecialidades() != null && !groomer.getEspecialidades().isEmpty()) {
                        String especialidades = groomer.getEspecialidades();
                        especialidades = especialidades.replace("√°", "á")
                                .replace("√©", "é")
                                .replace("√≠", "í")
                                .replace("√≥", "ó")
                                .replace("√ļ", "ú")
                                .replace("√Ī", "ñ")
                                .replace("√ģ", "Ñ")
                                .replace("‚ąöń™", "ñ");
                        groomer.setEspecialidades(especialidades);
                    }
                    // FIN CORRECCIÓN DE CARACTERES ESPECIALES

                    // Convertir especialidades JSON a texto legible
                    if (groomer.getEspecialidades() != null && !groomer.getEspecialidades().isEmpty()) {
                        try {
                            String especialidadesTexto = convertirJSONArrayATexto(groomer.getEspecialidades());
                            if (!especialidadesTexto.isEmpty()) {
                                groomer.setEspecialidades(especialidadesTexto);
                            }
                        } catch (Exception e) {
                            // Si hay error al parsear, dejar el JSON original
                            System.out.println("Error parseando especialidades: " + e.getMessage());
                        }
                    }

                    // ⚠️ COMENTA ESTA PARTE - Deja la disponibilidad como JSON original
                    // para que el JSP pueda parsearlo correctamente
                    /*
                // Convertir disponibilidad JSON a texto legible
                if (groomer.getDisponibilidad() != null && !groomer.getDisponibilidad().isEmpty()) {
                    try {
                        String disponibilidadTexto = convertirJSONObjectATexto(groomer.getDisponibilidad());
                        if (!disponibilidadTexto.isEmpty()) {
                            groomer.setDisponibilidad(disponibilidadTexto);
                        }
                    } catch (Exception e) {
                        // Si hay error al parsear, dejar el JSON original
                        System.out.println("Error parseando disponibilidad: " + e.getMessage());
                    }
                }
                     */
                }
            }

            // Establecer atributos
            request.setAttribute("groomers", groomers);
            request.setAttribute("totalGroomers", groomers != null ? groomers.size() : 0);

            System.out.println("📋 Atributos establecidos - redirigiendo a ListaGroomers.jsp");

        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();

            // En caso de error, enviar lista vacía
            request.setAttribute("groomers", new ArrayList<Groomer>());
            request.setAttribute("totalGroomers", 0);
            request.setAttribute("mensaje", "❌ Error al cargar groomers");
        }

        request.getRequestDispatcher("ListaGroomers.jsp").forward(request, response);
    }

    // MÉTODO: Obtener tiempos promedio de groomers
    private void obtenerTiemposPromedio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("=== OBTENIENDO TIEMPOS PROMEDIO DE GROOMERS ===");

            // Obtener parámetros de fecha
            String fechaInicioStr = limpiarParametro(request.getParameter("fechaInicio"));
            String fechaFinStr = limpiarParametro(request.getParameter("fechaFin"));

            // Validar fechas
            Date fechaInicio, fechaFin;
            if (fechaInicioStr == null || fechaInicioStr.isEmpty()) {
                // Fecha por defecto: hace 30 días
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.DAY_OF_MONTH, -30);
                fechaInicio = new Date(cal.getTimeInMillis());
            } else {
                fechaInicio = Date.valueOf(fechaInicioStr);
            }

            if (fechaFinStr == null || fechaFinStr.isEmpty()) {
                // Fecha por defecto: hoy
                fechaFin = new Date(System.currentTimeMillis());
            } else {
                fechaFin = Date.valueOf(fechaFinStr);
            }

            System.out.println("📅 Fecha inicio: " + fechaInicio);
            System.out.println("📅 Fecha fin: " + fechaFin);

            GroomerDao dao = new GroomerDao();
            List<TiempoPromedioGroomerDTO> tiempos = dao.tiemposPromedioGroomer(fechaInicio, fechaFin);

            System.out.println("✅ Tiempos promedio obtenidos: " + (tiempos != null ? tiempos.size() : "null"));

            // Establecer atributos
            request.setAttribute("tiemposPromedio", tiempos);
            request.setAttribute("fechaInicio", fechaInicio);
            request.setAttribute("fechaFin", fechaFin);
            request.setAttribute("totalRegistros", tiempos != null ? tiempos.size() : 0);

        } catch (IllegalArgumentException e) {
            System.out.println("ERROR: Formato de fecha inválido");
            request.setAttribute("mensaje", "❌ Error: Formato de fecha inválido. Use YYYY-MM-DD");
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensaje", "❌ Error al cargar tiempos promedio: " + e.getMessage());
        }

        request.getRequestDispatcher("TiemposPromedioGroomers.jsp").forward(request, response);
    }

    // MÉTODO: Obtener ocupación de groomers
    private void obtenerOcupacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("=== OBTENIENDO OCUPACIÓN DE GROOMERS ===");

            // Obtener parámetro de fecha
            String fechaStr = limpiarParametro(request.getParameter("fecha"));

            // Validar fecha
            Date fecha;
            if (fechaStr == null || fechaStr.isEmpty()) {
                // Fecha por defecto: hoy
                fecha = new Date(System.currentTimeMillis());
            } else {
                fecha = Date.valueOf(fechaStr);
            }

            System.out.println("📅 Fecha consulta: " + fecha);

            GroomerDao dao = new GroomerDao();
            List<OcupacionGroomerDTO> ocupaciones = dao.ocupacionGroomer(fecha);

            System.out.println("✅ Ocupaciones obtenidas: " + (ocupaciones != null ? ocupaciones.size() : "null"));

            // Establecer atributos
            request.setAttribute("ocupaciones", ocupaciones);
            request.setAttribute("fechaConsulta", fecha);
            request.setAttribute("totalRegistros", ocupaciones != null ? ocupaciones.size() : 0);

        } catch (IllegalArgumentException e) {
            System.out.println("ERROR: Formato de fecha inválido");
            request.setAttribute("mensaje", "❌ Error: Formato de fecha inválido. Use YYYY-MM-DD");
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensaje", "❌ Error al cargar ocupación: " + e.getMessage());
        }

        request.getRequestDispatcher("OcupacionGroomers.jsp").forward(request, response);
    }

    // MÉTODO: Obtener disponibilidad de groomers
    private void obtenerDisponibilidad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("=== OBTENIENDO DISPONIBILIDAD DE GROOMERS ===");

            // Obtener parámetro de fecha
            String fechaStr = limpiarParametro(request.getParameter("fecha"));

            // Validar fecha
            Date fecha;
            if (fechaStr == null || fechaStr.isEmpty()) {
                // Fecha por defecto: hoy
                fecha = new Date(System.currentTimeMillis());
            } else {
                fecha = Date.valueOf(fechaStr);
            }

            System.out.println("📅 Fecha consulta disponibilidad: " + fecha);

            GroomerDao dao = new GroomerDao();
            List<GroomerDisponibilidadDTO> disponibilidad = dao.obtenerDisponibilidadGroomers(fecha);

            System.out.println("✅ Disponibilidad obtenida: " + (disponibilidad != null ? disponibilidad.size() : "null"));

            // Establecer atributos
            request.setAttribute("disponibilidad", disponibilidad);
            request.setAttribute("fechaConsulta", fecha);
            request.setAttribute("totalGroomers", disponibilidad != null ? disponibilidad.size() : 0);

            // Calcular estadísticas
            if (disponibilidad != null && !disponibilidad.isEmpty()) {
                int totalAtenciones = 0;
                int groomersDisponibles = 0;
                int groomersOcupados = 0;

                for (GroomerDisponibilidadDTO groomer : disponibilidad) {
                    totalAtenciones += groomer.getAtencionesProgramadas();
                    if (groomer.getAtencionesProgramadas() == 0) {
                        groomersDisponibles++;
                    } else {
                        groomersOcupados++;
                    }
                }

                request.setAttribute("totalAtenciones", totalAtenciones);
                request.setAttribute("groomersDisponibles", groomersDisponibles);
                request.setAttribute("groomersOcupados", groomersOcupados);
                request.setAttribute("promedioAtenciones", totalAtenciones / disponibilidad.size());
            }

        } catch (IllegalArgumentException e) {
            System.out.println("ERROR: Formato de fecha inválido");
            request.setAttribute("mensaje", "❌ Error: Formato de fecha inválido. Use YYYY-MM-DD");
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensaje", "❌ Error al cargar disponibilidad: " + e.getMessage());
        }

        request.getRequestDispatcher("DisponibilidadGroomers.jsp").forward(request, response);
    }

    // MÉTODO: Mostrar formulario para insertar
    private void mostrarFormularioInsertar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("InsertarGroomer.jsp").forward(request, response);
    }

    // MÉTODO: Mostrar formulario para actualizar
    private void mostrarFormularioActualizar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idGroomerStr = limpiarParametro(request.getParameter("idGroomer"));

            if (idGroomerStr != null && !idGroomerStr.isEmpty()) {
                int idGroomer = Integer.parseInt(idGroomerStr);

                // Obtener todos los groomers para encontrar el específico
                GroomerDao dao = new GroomerDao();
                List<Groomer> groomers = dao.obtenerGroomers();

                // Buscar el groomer específico
                Groomer groomerSeleccionado = null;
                for (Groomer groomer : groomers) {
                    if (groomer.getIdGroomer() == idGroomer) {
                        groomerSeleccionado = groomer;
                        break;
                    }
                }

                if (groomerSeleccionado != null) {
                    request.setAttribute("groomer", groomerSeleccionado);
                } else {
                    request.setAttribute("mensaje", "❌ Groomer no encontrado con ID: " + idGroomer);
                }
            }
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar datos del groomer: " + e.getMessage());
        }

        request.getRequestDispatcher("ActualizarGroomer.jsp").forward(request, response);
    }

    // Método auxiliar para limpiar parámetros
    private String limpiarParametro(String param) {
        if (param == null) {
            return "";
        }
        return param.trim();
    }

    // Método para validar JSON array
    private boolean esValidoJSONArray(String jsonStr) {
        if (jsonStr == null || jsonStr.isEmpty()) {
            return false;
        }
        try {
            // Validación simple: debe empezar con [ y terminar con ]
            return jsonStr.trim().startsWith("[") && jsonStr.trim().endsWith("]");
        } catch (Exception e) {
            System.out.println("JSON array inválido: " + jsonStr);
            return false;
        }
    }

    // Método para validar JSON object
    private boolean esValidoJSONObject(String jsonStr) {
        if (jsonStr == null || jsonStr.isEmpty()) {
            return false;
        }
        try {
            // Validación simple: debe empezar con { y terminar con }
            return jsonStr.trim().startsWith("{") && jsonStr.trim().endsWith("}");
        } catch (Exception e) {
            System.out.println("JSON object inválido: " + jsonStr);
            return false;
        }
    }

    // Método para convertir JSON array a texto legible
    private String convertirJSONArrayATexto(String jsonArrayStr) {
        if (jsonArrayStr == null || jsonArrayStr.isEmpty()) {
            return "";
        }

        try {
            // Remover corchetes y comillas
            String texto = jsonArrayStr
                    .replace("[", "")
                    .replace("]", "")
                    .replace("\"", "")
                    .trim();

            // Si está vacío después de limpiar
            if (texto.isEmpty()) {
                return "";
            }

            return texto;
        } catch (Exception e) {
            System.out.println("Error convirtiendo JSON array a texto: " + e.getMessage());
            return jsonArrayStr; // Devolver original si hay error
        }
    }

    // Método para convertir JSON object a texto legible
    private String convertirJSONObjectATexto(String jsonObjectStr) {
        if (jsonObjectStr == null || jsonObjectStr.isEmpty()) {
            return "";
        }

        try {
            StringBuilder texto = new StringBuilder();

            // Convertir formato simple: {"dias":["lunes","martes"],"horaInicio":"08:00","horaFin":"17:00"}
            // a: "Días: Lunes, Martes | Horario: 08:00 - 17:00"
            String limpio = jsonObjectStr
                    .replace("{", "")
                    .replace("}", "")
                    .replace("\"", "")
                    .trim();

            if (limpio.isEmpty()) {
                return "";
            }

            String[] partes = limpio.split(",");
            List<String> dias = new ArrayList<>();
            String horaInicio = "";
            String horaFin = "";

            for (String parte : partes) {
                String[] keyValue = parte.split(":");
                if (keyValue.length == 2) {
                    String key = keyValue[0].trim();
                    String value = keyValue[1].trim();

                    if (key.equals("dias")) {
                        // Procesar array de días
                        String diasStr = value.replace("[", "").replace("]", "");
                        String[] diasArray = diasStr.split(",");
                        for (String dia : diasArray) {
                            String diaLimpio = dia.trim();
                            if (!diaLimpio.isEmpty()) {
                                // Capitalizar primera letra
                                dias.add(diaLimpio.substring(0, 1).toUpperCase() + diaLimpio.substring(1));
                            }
                        }
                    } else if (key.equals("horaInicio")) {
                        horaInicio = value;
                    } else if (key.equals("horaFin")) {
                        horaFin = value;
                    }
                }
            }

            // Construir texto legible
            if (!dias.isEmpty()) {
                texto.append("Días: ");
                for (int i = 0; i < dias.size(); i++) {
                    if (i > 0) {
                        texto.append(", ");
                    }
                    texto.append(dias.get(i));
                }
            }

            if (!horaInicio.isEmpty() && !horaFin.isEmpty()) {
                if (texto.length() > 0) {
                    texto.append(" | ");
                }
                texto.append("Horario: ").append(horaInicio).append(" - ").append(horaFin);
            }

            return texto.toString();

        } catch (Exception e) {
            System.out.println("Error convirtiendo JSON object a texto: " + e.getMessage());
            return jsonObjectStr; // Devolver original si hay error
        }
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
        return "Controlador para gestión completa de groomers";
    }
}
