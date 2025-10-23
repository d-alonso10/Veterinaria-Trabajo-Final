package control;

import dao.PaqueteServicioDao;
import dao.ServicioDao;
import modelo.PaqueteServicio;
import modelo.PaqueteServicioItem;
import modelo.Servicio;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/PaqueteServicioControlador"})
public class PaqueteServicioControlador extends HttpServlet {

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
                        crearPaqueteServicio(request, response);
                        break;
                    case "agregarServicio":
                        agregarServicioAPaquete(request, response);
                        break;
                    case "listarPaquetes":
                        listarPaquetesServicio(request, response);
                        break;
                    case "obtenerDetalle":
                        obtenerDetallePaquete(request, response);
                        break;
                    case "actualizar":
                        actualizarPaqueteServicio(request, response);
                        break;
                    case "eliminar":
                        eliminarPaqueteServicio(request, response);
                        break;
                    case "eliminarServicioPaquete":
                        eliminarServicioDePaquete(request, response);
                        break;
                    case "buscarPaquetes":
                        buscarPaquetesServicio(request, response);
                        break;
                    case "listar":
                        listarPaquetesServicio(request, response);
                        break;
                    case "mostrarFormulario":
                        mostrarFormularioCreacion(request, response);
                        break;
                    default:
                        listarPaquetesServicio(request, response);
                }
            } else {
                listarPaquetesServicio(request, response);
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error general en el controlador de paquetes de servicios");
        }
    }

    /**
     * Crea un nuevo paquete de servicios
     */
    private void crearPaqueteServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener parámetros
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String descripcion = limpiarParametro(request.getParameter("descripcion"));
            String precioTotalStr = limpiarParametro(request.getParameter("precioTotal"));

            // Validaciones básicas
            if (nombre.isEmpty() || descripcion.isEmpty() || precioTotalStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Nombre, descripción y precio total son obligatorios");
                request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                return;
            }

            // Validar longitud del nombre
            if (nombre.length() < 3 || nombre.length() > 100) {
                request.setAttribute("mensaje", "❌ El nombre debe tener entre 3 y 100 caracteres");
                request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                return;
            }

            // Validar longitud de la descripción
            if (descripcion.length() > 500) {
                request.setAttribute("mensaje", "❌ La descripción no puede exceder 500 caracteres");
                request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                return;
            }

            // Validar y convertir precio
            double precioTotal;
            try {
                precioTotal = Double.parseDouble(precioTotalStr);
                if (precioTotal <= 0) {
                    throw new NumberFormatException("Precio debe ser positivo");
                }
                
                if (precioTotal > 10000.00) {
                    request.setAttribute("mensaje", "❌ El precio no puede exceder $10,000.00");
                    request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ Precio total inválido");
                request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                return;
            }

            // Crear objeto PaqueteServicio
            PaqueteServicio paquete = new PaqueteServicio();
            paquete.setNombre(nombre);
            paquete.setDescripcion(descripcion);
            paquete.setPrecioTotal(precioTotal);

            // Crear paquete en la base de datos
            PaqueteServicioDao dao = new PaqueteServicioDao();
            int idPaqueteCreado = dao.crearPaqueteServicio(paquete);

            if (idPaqueteCreado > 0) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=listar&creado=exito&id=" + idPaqueteCreado);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al crear el paquete de servicios");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al crear paquete de servicios");
            return;
        }

        // Solo usar forward en caso de error para mostrar el mensaje en el formulario
        request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
    }

    /**
     * Agrega un servicio a un paquete existente
     */
    private void agregarServicioAPaquete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Vista para mostrar errores (el formulario de agregar)
        String vistaError = "AgregarServicioPaquete.jsp";
        int idPaquete = 0; // Inicializar para la URL de redirección
        
        try {
            // Obtener parámetros
            String idPaqueteStr = limpiarParametro(request.getParameter("idPaquete"));
            String idServicioStr = limpiarParametro(request.getParameter("idServicio"));
            String cantidadStr = limpiarParametro(request.getParameter("cantidad"));

            // Validaciones básicas
            if (idPaqueteStr.isEmpty() || idServicioStr.isEmpty() || cantidadStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Paquete, servicio y cantidad son obligatorios");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            // Conversiones numéricas
            int idServicio, cantidad;
            try {
                idPaquete = Integer.parseInt(idPaqueteStr); // Asignar a la variable de alcance
                idServicio = Integer.parseInt(idServicioStr);
                cantidad = Integer.parseInt(cantidadStr);

                if (idPaquete <= 0 || idServicio <= 0 || cantidad <= 0) {
                    throw new NumberFormatException("Los valores deben ser positivos");
                }

                if (cantidad > 20) {
                    request.setAttribute("mensaje", "❌ La cantidad no puede exceder 20 unidades por servicio");
                    request.getRequestDispatcher(vistaError).forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ IDs o cantidad inválidos");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            // Validar que el servicio existe
            ServicioDao servicioDao = new ServicioDao();
            Servicio servicio = servicioDao.obtenerServicioPorId(idServicio);
            if (servicio == null) {
                request.setAttribute("mensaje", "❌ Servicio no encontrado");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            // Validar que el paquete existe
            PaqueteServicioDao paqueteDao = new PaqueteServicioDao();
            PaqueteServicio paquete = paqueteDao.obtenerPaquetePorId(idPaquete);
            if (paquete == null) {
                request.setAttribute("mensaje", "❌ Paquete no encontrado");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            // Verificar que el servicio no esté ya en el paquete
            if (paqueteDao.servicioYaEnPaquete(idPaquete, idServicio)) {
                request.setAttribute("mensaje", "❌ Este servicio ya está incluido en el paquete");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            // Crear objeto PaqueteServicioItem
            PaqueteServicioItem item = new PaqueteServicioItem();
            item.setIdPaquete(idPaquete);
            item.setIdServicio(idServicio);
            item.setCantidad(cantidad);

            // Agregar servicio al paquete
            boolean exito = paqueteDao.agregarServicioPaquete(item);

            if (exito) {
                // ****** INICIO DE CORRECCIÓN PRG ******
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=obtenerDetalle&idPaquete=" + idPaquete + "&agregado=exito");
                return; // Importante añadir return
                // ****** FIN DE CORRECCIÓN PRG ******
            } else {
                request.setAttribute("mensaje", "❌ Error al agregar el servicio al paquete");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (Exception e) {
            // Si idPaquete se pudo parsear, al menos podemos intentar redirigir al detalle
            if (idPaquete > 0) {
                 response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=obtenerDetalle&idPaquete=" + idPaquete + "&error=sistema");
                 return;
            }
            // Si no, manejar error genérico
            manejarError(request, response, e, "Error al agregar servicio al paquete");
            return;
        }
        
        // Solo usar forward en caso de error NO manejado por redirect
        request.getRequestDispatcher(vistaError).forward(request, response);
    }

    /**
     * Lista todos los paquetes de servicios disponibles
     */
    private void listarPaquetesServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Verificar mensajes de éxito de acciones PRG
            String creado = request.getParameter("creado");
            String actualizado = request.getParameter("actualizado");
            String eliminado = request.getParameter("eliminado");
            String idParam = request.getParameter("id");

            if ("exito".equals(creado)) {
                request.setAttribute("mensaje", "✅ Paquete de servicios creado exitosamente" + (idParam != null ? " con ID: " + idParam : ""));
                request.setAttribute("tipoMensaje", "exito");
            } else if ("exito".equals(actualizado)) {
                request.setAttribute("mensaje", "✅ Paquete de servicios actualizado exitosamente" + (idParam != null ? " ID: " + idParam : ""));
                request.setAttribute("tipoMensaje", "exito");
            } else if ("exito".equals(eliminado)) {
                request.setAttribute("mensaje", "✅ Paquete de servicios eliminado exitosamente" + (idParam != null ? " ID: " + idParam : ""));
                request.setAttribute("tipoMensaje", "exito");
            }

            PaqueteServicioDao dao = new PaqueteServicioDao();
            List<PaqueteServicio> paquetes = dao.listarPaquetesServicio();

            if (paquetes != null && !paquetes.isEmpty()) {
                request.setAttribute("paquetesServicio", paquetes);
                request.setAttribute("totalPaquetes", paquetes.size());

                // Calcular estadísticas
                double precioMinimo = Double.MAX_VALUE;
                double precioMaximo = 0.0;
                double promedioPrecios = 0.0;
                // int paquetesActivos = 0; // CAMBIO: Eliminado, campo 'estado' no existe

                for (PaqueteServicio paquete : paquetes) {
                    double precio = paquete.getPrecioTotal();
                    if (precio < precioMinimo) precioMinimo = precio;
                    if (precio > precioMaximo) precioMaximo = precio;
                    promedioPrecios += precio;
                    
                    // CAMBIO: Lógica de 'estado' eliminada
                    // if ("ACTIVO".equals(paquete.getEstado())) {
                    //     paquetesActivos++;
                    // }
                }

                if (paquetes.size() > 0) {
                    promedioPrecios /= paquetes.size();
                    request.setAttribute("precioMinimo", precioMinimo);
                    request.setAttribute("precioMaximo", precioMaximo);
                    request.setAttribute("promedioPrecios", promedioPrecios);
                }
                
                // request.setAttribute("paquetesActivos", paquetesActivos); // CAMBIO: Eliminado
                
                // No sobreescribir mensajes de éxito
                if (request.getAttribute("mensaje") == null) {
                    request.setAttribute("mensaje", "✅ Se encontraron " + paquetes.size() + " paquetes de servicios");
                }
            } else {
                request.setAttribute("paquetesServicio", null);
                 if (request.getAttribute("mensaje") == null) {
                    request.setAttribute("mensaje", "ℹ️ No existen paquetes de servicios registrados");
                 }
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar paquetes de servicios");
            return;
        }

        request.getRequestDispatcher("ListaPaquetesServicios.jsp").forward(request, response);
    }

    /**
     * Obtiene el detalle completo de un paquete específico
     */
    private void obtenerDetallePaquete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idPaqueteStr = limpiarParametro(request.getParameter("idPaquete"));

            if (idPaqueteStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de paquete requerido");
                request.getRequestDispatcher("ListaPaquetesServicios.jsp").forward(request, response);
                return;
            }

            int idPaquete = Integer.parseInt(idPaqueteStr);

            // Verificar si viene de una acción PRG
            String servicioEliminado = request.getParameter("servicioEliminado");
            String servicioAgregado = request.getParameter("agregado");
            String errorSistema = request.getParameter("error");

            if ("exito".equals(servicioEliminado)) {
                request.setAttribute("mensaje", "✅ Servicio eliminado del paquete exitosamente");
                request.setAttribute("tipoMensaje", "exito");
            } else if ("exito".equals(servicioAgregado)) {
                request.setAttribute("mensaje", "✅ Servicio agregado al paquete exitosamente");
                request.setAttribute("tipoMensaje", "exito");
            } else if ("sistema".equals(errorSistema)) {
                request.setAttribute("mensaje", "❌ Error del sistema al modificar el paquete");
                request.setAttribute("tipoMensaje", "error");
            }


            PaqueteServicioDao dao = new PaqueteServicioDao();
            PaqueteServicio paquete = dao.obtenerPaquetePorId(idPaquete);

            if (paquete != null) {
                request.setAttribute("paqueteDetalle", paquete);

                // Obtener servicios del paquete
                List<PaqueteServicioItem> serviciosPaquete = dao.obtenerServiciosPaquete(idPaquete);
                if (serviciosPaquete != null && !serviciosPaquete.isEmpty()) {
                    request.setAttribute("serviciosPaquete", serviciosPaquete);
                    request.setAttribute("totalServicios", serviciosPaquete.size());

                    // Calcular valor total de servicios individuales
                    double valorIndividual = 0.0;
                    for (PaqueteServicioItem item : serviciosPaquete) {
                        valorIndividual += (item.getPrecioUnitario() * item.getCantidad());
                    }
                    
                    request.setAttribute("valorIndividual", valorIndividual);
                    request.setAttribute("ahorroEstimado", valorIndividual - paquete.getPrecioTotal());
                    request.setAttribute("porcentajeDescuento", 
                        valorIndividual > 0 ? ((valorIndividual - paquete.getPrecioTotal()) / valorIndividual) * 100 : 0);
                } else {
                    request.setAttribute("serviciosPaquete", null);
                    if (request.getAttribute("mensaje") == null) { // No sobreescribir mensajes de éxito/error
                        request.setAttribute("mensaje", "⚠️ Este paquete no tiene servicios asociados");
                    }
                }

                if (request.getAttribute("mensaje") == null) {
                    request.setAttribute("mensaje", "✅ Detalle del paquete cargado correctamente");
                }
            } else {
                request.setAttribute("mensaje", "❌ Paquete no encontrado");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de paquete inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al obtener detalle del paquete");
            return;
        }

        request.getRequestDispatcher("DetallePaqueteServicio.jsp").forward(request, response);
    }

    /**
     * Actualiza la información de un paquete existente
     */
    private void actualizarPaqueteServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String vistaError = "EditarPaqueteServicio.jsp";
        
        try {
            String idPaqueteStr = limpiarParametro(request.getParameter("idPaquete"));
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String descripcion = limpiarParametro(request.getParameter("descripcion"));
            String precioTotalStr = limpiarParametro(request.getParameter("precioTotal"));
            // String estado = limpiarParametro(request.getParameter("estado")); // CAMBIO: Eliminado

            // Validaciones básicas
            if (idPaqueteStr.isEmpty() || nombre.isEmpty() || descripcion.isEmpty() || precioTotalStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID, nombre, descripción y precio son obligatorios");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            // Conversiones
            int idPaquete = Integer.parseInt(idPaqueteStr);
            double precioTotal = Double.parseDouble(precioTotalStr);

            // Validaciones de negocio
            if (precioTotal <= 0) {
                request.setAttribute("mensaje", "❌ El precio debe ser mayor a cero");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            // CAMBIO: Lógica de validación de 'estado' eliminada
            
            PaqueteServicioDao dao = new PaqueteServicioDao();
            // CAMBIO: Llamada al DAO sin el parámetro 'estado'
            boolean exito = dao.actualizarPaqueteServicio(idPaquete, nombre, descripcion, precioTotal);

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=listar&actualizado=exito&id=" + idPaquete);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al actualizar el paquete");
                request.setAttribute("tipoMensaje", "error");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Datos numéricos inválidos");
            request.getRequestDispatcher(vistaError).forward(request, response);
            return;
        } catch (Exception e) {
            manejarError(request, response, e, "Error al actualizar paquete de servicios");
            return;
        }
    }

    /**
     * Elimina un paquete de servicios (borrado físico)
     */
    private void eliminarPaqueteServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idPaqueteStr = limpiarParametro(request.getParameter("idPaquete"));

            if (idPaqueteStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de paquete requerido");
                request.getRequestDispatcher("ListaPaquetesServicios.jsp").forward(request, response);
                return;
            }

            int idPaquete = Integer.parseInt(idPaqueteStr);

            PaqueteServicioDao dao = new PaqueteServicioDao();
            boolean exito = dao.eliminarPaqueteServicio(idPaquete);

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=listar&eliminado=exito&id=" + idPaquete);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al eliminar el paquete (verifique dependencias)");
                request.setAttribute("tipoMensaje", "error");
                listarPaquetesServicio(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de paquete inválido");
            listarPaquetesServicio(request, response);
            return;
        } catch (Exception e) {
            manejarError(request, response, e, "Error al eliminar paquete de servicios");
            return;
        }
    }

    /**
     * Elimina un servicio específico de un paquete
     */
    private void eliminarServicioDePaquete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idPaqueteStr = limpiarParametro(request.getParameter("idPaquete")); // Obtener ID paquete
        
        try {
            String idServicioStr = limpiarParametro(request.getParameter("idServicio"));

            if (idPaqueteStr.isEmpty() || idServicioStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de paquete e ID de servicio son requeridos");
                request.getRequestDispatcher("DetallePaqueteServicio.jsp").forward(request, response);
                return;
            }

            int idPaquete = Integer.parseInt(idPaqueteStr);
            int idServicio = Integer.parseInt(idServicioStr);

            PaqueteServicioDao dao = new PaqueteServicioDao();
            boolean exito = dao.eliminarServicioPaquete(idPaquete, idServicio);

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=obtenerDetalle&idPaquete=" + idPaquete + "&servicioEliminado=exito");
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al eliminar el servicio del paquete");
                request.setAttribute("tipoMensaje", "error");
                // Recargar el detalle del paquete
                request.setAttribute("idPaquete", idPaqueteStr); // Asegurarse que el ID esté en el request
                obtenerDetallePaquete(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ IDs proporcionados inválidos");
            request.getRequestDispatcher("DetallePaqueteServicio.jsp").forward(request, response);
        } catch (Exception e) {
             // Redirigir al detalle del paquete si falló
             if (!idPaqueteStr.isEmpty()) {
                 response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=obtenerDetalle&idPaquete=" + idPaqueteStr + "&error=sistema");
                 return;
             }
            manejarError(request, response, e, "Error al eliminar servicio del paquete");
        }
    }

    /**
     * Busca paquetes por diferentes criterios
     */
    private void buscarPaquetesServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String termino = limpiarParametro(request.getParameter("termino"));
            // String estado = limpiarParametro(request.getParameter("estado")); // CAMBIO: Eliminado
            String precioMinStr = limpiarParametro(request.getParameter("precioMin"));
            String precioMaxStr = limpiarParametro(request.getParameter("precioMax"));

            PaqueteServicioDao dao = new PaqueteServicioDao();
            List<PaqueteServicio> paquetes = null;

            // Conversión de precios si se proporcionan
            Double precioMin = null, precioMax = null;
            if (!precioMinStr.isEmpty()) {
                try {
                    precioMin = Double.parseDouble(precioMinStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "⚠️ Precio mínimo inválido, ignorando criterio");
                }
            }

            if (!precioMaxStr.isEmpty()) {
                try {
                    precioMax = Double.parseDouble(precioMaxStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "⚠️ Precio máximo inválido, ignorando criterio");
                }
            }

            // Búsqueda con criterios
            // CAMBIO: Llamada al DAO sin el parámetro 'estado'
            paquetes = dao.buscarPaquetesServicio(termino, null, precioMin, precioMax);

            if (paquetes != null && !paquetes.isEmpty()) {
                request.setAttribute("paquetesServicio", paquetes);
                request.setAttribute("totalPaquetes", paquetes.size());
                request.setAttribute("mensaje", "✅ Se encontraron " + paquetes.size() + " paquetes");
            } else {
                request.setAttribute("paquetesServicio", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron paquetes con los criterios especificados");
            }

            // Mantener parámetros de búsqueda
            request.setAttribute("terminoBusqueda", termino);
            // request.setAttribute("estadoBusqueda", estado); // CAMBIO: Eliminado
            request.setAttribute("precioMinBusqueda", precioMinStr);
            request.setAttribute("precioMaxBusqueda", precioMaxStr);

        } catch (Exception e) {
            manejarError(request, response, e, "Error al buscar paquetes de servicios");
            return;
        }

        request.getRequestDispatcher("BuscarPaquetesServicios.jsp").forward(request, response);
    }

    /**
     * Manejo centralizado de errores
     */
    private void manejarError(HttpServletRequest request, HttpServletResponse response, 
                             Exception e, String mensajeContexto) 
            throws ServletException, IOException {
        
        System.err.println("=== ERROR EN PAQUETE SERVICIO CONTROLADOR ===");
        System.err.println("Contexto: " + mensajeContexto);
        System.err.println("Mensaje: " + e.getMessage());
        e.printStackTrace();

        request.setAttribute("mensaje", "❌ " + mensajeContexto + ": " + e.getMessage());
        request.setAttribute("tipoMensaje", "error");
        
        request.getRequestDispatcher("ListaPaquetesServicios.jsp").forward(request, response);
    }

    /**
     * Muestra el formulario de creación de paquetes de servicios
     */
    private void mostrarFormularioCreacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Cargar lista de servicios disponibles para el formulario
            ServicioDao servicioDao = new ServicioDao();
            List<Servicio> serviciosDisponibles = servicioDao.obtenerServicios();
            request.setAttribute("serviciosDisponibles", serviciosDisponibles);
        } catch (Exception e) {
            System.err.println("Error al cargar servicios para formulario: " + e.getMessage());
        }
        
        // Mostrar el formulario
        request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
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
        return "Controlador para gestión completa de paquetes de servicios";
    }
}