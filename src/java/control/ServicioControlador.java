package control;

import dao.ServicioDao;
import java.io.IOException;
import java.sql.Date;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Servicio;
import modelo.ServicioMasSolicitadoDTO;

@WebServlet(urlPatterns = {"/ServicioControlador"})
public class ServicioControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar encoding ANTES de obtener parámetros
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String acc = request.getParameter("acc");
        String accion = request.getParameter("accion");

        System.out.println("=== 🚀 SERVICIO CONTROLADOR INICIADO ===");
        System.out.println("📥 acc: '" + acc + "'");
        System.out.println("📥 accion: '" + accion + "'");

        try {
            // 1. Primero manejar el parámetro "acc" (para insertar/actualizar)
            if (acc != null && acc.equals("Confirmar")) {
                // DETECTAR SI ES INSERTAR O ACTUALIZAR
                String idServicioStr = request.getParameter("idServicio");
                System.out.println("🔍 Detectando tipo de operación - idServicio: '" + idServicioStr + "'");

                if (idServicioStr != null && !idServicioStr.isEmpty()) {
                    System.out.println("🎯 Ejecutando ACTUALIZAR servicio desde acc=Confirmar");
                    actualizarServicio(request, response);
                } else {
                    System.out.println("🎯 Ejecutando INSERTAR servicio desde acc=Confirmar");
                    insertarServicio(request, response);
                }
                return;
            }

            // 2. Luego manejar el parámetro "accion" 
            if (accion != null) {
                System.out.println("🎯 Ejecutando acción específica: " + accion);
                switch (accion) {
                    case "actualizar":
                        actualizarServicio(request, response);
                        return;
                    case "listar":
                        listarServicios(request, response);
                        return;
                    case "serviciosMasSolicitados":
                        obtenerServiciosMasSolicitados(request, response);
                        return;
                    case "porCategoria":
                        obtenerServiciosPorCategoria(request, response);
                        return;
                    case "formularioActualizar":
                        mostrarFormularioActualizar(request, response);
                        return;
                    case "formularioInsertar":
                        mostrarFormularioInsertar(request, response);
                        return;
                    default:
                        System.out.println("❌ Acción no reconocida: " + accion);
                    // Caer al caso por defecto
                }
            }

            // 3. Caso por defecto (sin parámetros o acción no reconocida)
            System.out.println("🎯 Ejecutando caso por defecto: listarServicios");
            listarServicios(request, response);

        } catch (Exception e) {
            System.out.println("💥 ERROR en processRequest: " + e.getMessage());
            e.printStackTrace();
            try {
                request.setAttribute("mensaje", "❌ Error: " + e.getMessage());
                request.getRequestDispatcher("ListaServicios.jsp").forward(request, response);
            } catch (Exception ex) {
                System.out.println("💥 ERROR en manejo de error: " + ex.getMessage());
            }
        }

        System.out.println("=== ✅ SERVICIO CONTROLADOR FINALIZADO ===");
    }

    // MÉTODO: Insertar servicio
    private void insertarServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener y limpiar parámetros
            String codigo = limpiarParametro(request.getParameter("codigo"));
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String descripcion = limpiarParametro(request.getParameter("descripcion"));
            String duracionStr = limpiarParametro(request.getParameter("duracionEstimadaMin"));
            String precioStr = limpiarParametro(request.getParameter("precioBase"));
            String categoria = limpiarParametro(request.getParameter("categoria"));

            // Validaciones
            if (codigo == null || codigo.isEmpty()
                    || nombre == null || nombre.isEmpty()
                    || duracionStr == null || duracionStr.isEmpty()
                    || precioStr == null || precioStr.isEmpty()) {

                request.setAttribute("mensaje", "❌ Error: Código, Nombre, Duración y Precio son obligatorios");
                request.getRequestDispatcher("InsertarServicio.jsp").forward(request, response);
                return;
            }

            // Convertir números
            int duracionEstimadaMin;
            double precioBase;
            try {
                duracionEstimadaMin = Integer.parseInt(duracionStr);
                precioBase = Double.parseDouble(precioStr);
            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ Error: Duración y Precio deben ser números válidos");
                request.getRequestDispatcher("InsertarServicio.jsp").forward(request, response);
                return;
            }

            // Crear servicio
            Servicio servicio = new Servicio();
            servicio.setCodigo(codigo);
            servicio.setNombre(nombre);
            servicio.setDescripcion(descripcion);
            servicio.setDuracionEstimadaMin(duracionEstimadaMin);
            servicio.setPrecioBase(precioBase);
            servicio.setCategoria(categoria != null && !categoria.isEmpty() ? categoria : "otro");

            // Insertar
            ServicioDao dao = new ServicioDao();
            int idServicio = dao.insertarServicio(servicio);

            if (idServicio != -1) {
                request.setAttribute("mensaje", "✅ Servicio insertado con éxito (ID: " + idServicio + ")");
            } else {
                request.setAttribute("mensaje", "❌ Error al insertar servicio");
            }

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error del sistema: " + e.getMessage());
        }

        request.getRequestDispatcher("InsertarServicio.jsp").forward(request, response);
    }

 // MÉTODO: Actualizar servicio - MEJORADO
private void actualizarServicio(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        // Obtener y limpiar parámetros
        String idServicioStr = limpiarParametro(request.getParameter("idServicio"));
        String codigo = limpiarParametro(request.getParameter("codigo"));
        String nombre = limpiarParametro(request.getParameter("nombre"));
        String descripcion = limpiarParametro(request.getParameter("descripcion"));
        String duracionStr = limpiarParametro(request.getParameter("duracionEstimadaMin"));
        String precioStr = limpiarParametro(request.getParameter("precioBase"));
        String categoria = limpiarParametro(request.getParameter("categoria"));

        System.out.println("=== 🔄 SERVLET - INICIANDO ACTUALIZACIÓN ===");
        System.out.println("📥 PARÁMETROS RECIBIDOS:");
        System.out.println("   idServicio: '" + idServicioStr + "'");
        System.out.println("   codigo: '" + codigo + "'");
        System.out.println("   nombre: '" + nombre + "'");
        System.out.println("   descripcion: '" + descripcion + "'");
        System.out.println("   duracionStr: '" + duracionStr + "'");
        System.out.println("   precioStr: '" + precioStr + "'");
        System.out.println("   categoria: '" + categoria + "'");

        // Validaciones
        if (idServicioStr == null || idServicioStr.isEmpty()
                || codigo == null || codigo.isEmpty()
                || nombre == null || nombre.isEmpty()) {

            String mensajeError = "❌ Error: ID Servicio, Código y Nombre son obligatorios";
            System.out.println("💥 " + mensajeError);
            request.setAttribute("mensaje", mensajeError);
            request.getRequestDispatcher("ActualizarServicio.jsp").forward(request, response);
            return;
        }

        // Convertir ID
        int idServicio;
        try {
            idServicio = Integer.parseInt(idServicioStr);
            System.out.println("✅ ID Servicio convertido: " + idServicio);
        } catch (NumberFormatException e) {
            String mensajeError = "❌ Error: ID Servicio debe ser un número válido";
            System.out.println("💥 " + mensajeError);
            request.setAttribute("mensaje", mensajeError);
            request.getRequestDispatcher("ActualizarServicio.jsp").forward(request, response);
            return;
        }

        // Convertir números opcionales
        int duracionEstimadaMin = 0;
        double precioBase = 0.0;

        if (duracionStr != null && !duracionStr.isEmpty()) {
            try {
                duracionEstimadaMin = Integer.parseInt(duracionStr);
                System.out.println("✅ Duración convertida: " + duracionEstimadaMin);
            } catch (NumberFormatException e) {
                System.out.println("⚠️  Duración no válida, usando 0");
            }
        }

        if (precioStr != null && !precioStr.isEmpty()) {
            try {
                precioBase = Double.parseDouble(precioStr);
                System.out.println("✅ Precio convertido: " + precioBase);
            } catch (NumberFormatException e) {
                System.out.println("⚠️  Precio no válido, usando 0.0");
            }
        }

        System.out.println("🔧 VALORES FINALES PARA ACTUALIZACIÓN:");
        System.out.println("   idServicio: " + idServicio);
        System.out.println("   codigo: " + codigo);
        System.out.println("   nombre: " + nombre);
        System.out.println("   descripcion: " + descripcion);
        System.out.println("   duracionEstimadaMin: " + duracionEstimadaMin);
        System.out.println("   precioBase: " + precioBase);
        System.out.println("   categoria: " + categoria);

        ServicioDao dao = new ServicioDao();
        System.out.println("📡 LLAMANDO AL DAO PARA ACTUALIZAR...");
        boolean exito = dao.actualizarServicio(idServicio, codigo, nombre, descripcion, 
                                              duracionEstimadaMin, precioBase, categoria);

        if (exito) {
            String mensajeExito = "✅ Servicio actualizado con éxito";
            System.out.println("🎉 " + mensajeExito);
            
            // Redirigir a la lista después de actualizar exitosamente
            response.sendRedirect("ServicioControlador?accion=listar&mensaje=Servicio+actualizado+exitosamente");
            return;
        } else {
            String mensajeError = "❌ Error al actualizar servicio - Verifique los datos";
            System.out.println("💥 " + mensajeError);
            request.setAttribute("mensaje", mensajeError);
        }

    } catch (Exception e) {
        String mensajeError = "❌ Error al actualizar servicio: " + e.getMessage();
        System.out.println("💥 " + mensajeError);
        e.printStackTrace();
        request.setAttribute("mensaje", mensajeError);
    }

    // Si llegamos aquí, hubo un error, permanecer en el formulario
    request.getRequestDispatcher("ActualizarServicio.jsp").forward(request, response);
}

    // MÉTODO: Listar todos los servicios
    private void listarServicios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("=== OBTENIENDO TODOS LOS SERVICIOS ===");

            ServicioDao dao = new ServicioDao();
            List<Servicio> servicios = dao.obtenerServicios();

            System.out.println("✅ Servicios obtenidos: " + (servicios != null ? servicios.size() : "null"));

            // Establecer atributos
            request.setAttribute("servicios", servicios);
            request.setAttribute("totalServicios", servicios != null ? servicios.size() : 0);

            // Obtener categorías para filtros
            request.setAttribute("categorias", dao.obtenerCategoriasParaInterfaz());

        } catch (Exception e) {
            System.out.println("❌ ERROR en listarServicios: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensaje", "❌ Error al cargar servicios: " + e.getMessage());
        }

        request.getRequestDispatcher("ListaServicios.jsp").forward(request, response);
    }

    // MÉTODO: Obtener servicios más solicitados
    private void obtenerServiciosMasSolicitados(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String fechaInicioStr = limpiarParametro(request.getParameter("fechaInicio"));
            String fechaFinStr = limpiarParametro(request.getParameter("fechaFin"));

            Date fechaInicio = null;
            Date fechaFin = null;

            // Convertir fechas si están presentes
            if (fechaInicioStr != null && !fechaInicioStr.isEmpty()) {
                try {
                    fechaInicio = Date.valueOf(fechaInicioStr);
                } catch (IllegalArgumentException e) {
                    request.setAttribute("mensaje", "❌ Error: Formato de fecha de inicio inválido");
                    request.getRequestDispatcher("ServiciosMasSolicitados.jsp").forward(request, response);
                    return;
                }
            }

            if (fechaFinStr != null && !fechaFinStr.isEmpty()) {
                try {
                    fechaFin = Date.valueOf(fechaFinStr);
                } catch (IllegalArgumentException e) {
                    request.setAttribute("mensaje", "❌ Error: Formato de fecha de fin inválido");
                    request.getRequestDispatcher("ServiciosMasSolicitados.jsp").forward(request, response);
                    return;
                }
            }

            ServicioDao dao = new ServicioDao();
            List<ServicioMasSolicitadoDTO> serviciosMasSolicitados
                    = dao.serviciosMasSolicitados(fechaInicio, fechaFin);

            request.setAttribute("serviciosMasSolicitados", serviciosMasSolicitados);
            request.setAttribute("fechaInicio", fechaInicio);
            request.setAttribute("fechaFin", fechaFin);
            request.setAttribute("totalServicios", serviciosMasSolicitados != null ? serviciosMasSolicitados.size() : 0);

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar servicios más solicitados: " + e.getMessage());
        }

        request.getRequestDispatcher("ServiciosMasSolicitados.jsp").forward(request, response);
    }

    // MÉTODO: Obtener servicios por categoría
    private void obtenerServiciosPorCategoria(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String categoria = limpiarParametro(request.getParameter("categoria"));

            if (categoria == null || categoria.isEmpty()) {
                request.setAttribute("mensaje", "❌ Error: Categoría es requerida");
                request.getRequestDispatcher("ServiciosPorCategoria.jsp").forward(request, response);
                return;
            }

            ServicioDao dao = new ServicioDao();
            List<Servicio> servicios = dao.obtenerServiciosPorCategoria(categoria);

            request.setAttribute("servicios", servicios);
            request.setAttribute("categoria", categoria);
            request.setAttribute("totalServicios", servicios != null ? servicios.size() : 0);
            request.setAttribute("categorias", dao.obtenerCategoriasParaInterfaz());

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar servicios por categoría: " + e.getMessage());
        }

        request.getRequestDispatcher("ServiciosPorCategoria.jsp").forward(request, response);
    }

    // MÉTODO: Mostrar formulario de actualización
    private void mostrarFormularioActualizar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idServicioStr = limpiarParametro(request.getParameter("idServicio"));

            if (idServicioStr == null || idServicioStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Error: ID Servicio es requerido");
                request.getRequestDispatcher("ActualizarServicio.jsp").forward(request, response);
                return;
            }

            int idServicio = Integer.parseInt(idServicioStr);
            ServicioDao dao = new ServicioDao();

            // Obtener todos los servicios y buscar el específico
            List<Servicio> servicios = dao.obtenerServicios();
            Servicio servicio = null;

            for (Servicio s : servicios) {
                if (s.getIdServicio() == idServicio) {
                    servicio = s;
                    break;
                }
            }

            if (servicio != null) {
                request.setAttribute("servicio", servicio);
                request.setAttribute("categorias", dao.obtenerCategoriasParaInterfaz());
            } else {
                request.setAttribute("mensaje", "❌ Error: Servicio no encontrado");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Error: ID Servicio debe ser un número válido");
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar servicio: " + e.getMessage());
        }

        request.getRequestDispatcher("ActualizarServicio.jsp").forward(request, response);
    }

    // MÉTODO: Mostrar formulario de inserción
    private void mostrarFormularioInsertar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ServicioDao dao = new ServicioDao();
            request.setAttribute("categorias", dao.obtenerCategoriasParaInterfaz());
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar categorías: " + e.getMessage());
        }

        request.getRequestDispatcher("InsertarServicio.jsp").forward(request, response);
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
        return "Controlador para gestión completa de servicios";
    }
}
