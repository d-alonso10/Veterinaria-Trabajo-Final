package control;

import dao.PromocionDao;
import modelo.Promocion;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/PromocionControlador"})
public class PromocionControlador extends HttpServlet {

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
                        crearPromocion(request, response);
                        break;
                    case "listarActivas":
                        listarPromocionesActivas(request, response);
                        break;
                    case "listar":
                    case "listarTodas":
                        listarTodasPromociones(request, response);
                        break;
                    case "buscar":
                        buscarPromociones(request, response);
                        break;
                    case "obtenerDetalle":
                        obtenerDetallePromocion(request, response);
                        break;
                    case "actualizar":
                        actualizarPromocion(request, response);
                        break;
                    case "cambiarEstado":
                        cambiarEstadoPromocion(request, response);
                        break;
                    case "eliminar":
                        eliminarPromocion(request, response);
                        break;
                    case "validarPromocion":
                        validarPromocionParaCliente(request, response);
                        break;
                    case "mostrarFormulario":
                        mostrarFormularioCreacion(request, response);
                        break;
                    default:
                        listarTodasPromociones(request, response);
                }
            } else {
                listarTodasPromociones(request, response);
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error general en el controlador de promociones");
        }
    }

    /**
     * Crea una nueva promoción
     */
    private void crearPromocion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener parámetros
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String descripcion = limpiarParametro(request.getParameter("descripcion"));
            String tipo = limpiarParametro(request.getParameter("tipo"));
            String valorStr = limpiarParametro(request.getParameter("valor"));
            String fechaInicioStr = limpiarParametro(request.getParameter("fechaInicio"));
            String fechaFinStr = limpiarParametro(request.getParameter("fechaFin"));

            // Validaciones básicas
            if (nombre.isEmpty() || descripcion.isEmpty() || tipo.isEmpty() || 
                valorStr.isEmpty() || fechaInicioStr.isEmpty() || fechaFinStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Todos los campos son obligatorios");
                request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
                return;
            }

            // Validar longitud del nombre
            if (nombre.length() < 3 || nombre.length() > 100) {
                request.setAttribute("mensaje", "❌ El nombre debe tener entre 3 y 100 caracteres");
                request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
                return;
            }

            // Validar tipos permitidos
            String[] tiposPermitidos = {"DESCUENTO_PORCENTAJE", "DESCUENTO_FIJO", "2X1", "REGALO", "PUNTOS_DOBLES"};
            boolean tipoValido = false;
            for (String tipoPermitido : tiposPermitidos) {
                if (tipoPermitido.equals(tipo.toUpperCase())) {
                    tipo = tipoPermitido;
                    tipoValido = true;
                    break;
                }
            }

            if (!tipoValido) {
                request.setAttribute("mensaje", "❌ Tipo de promoción no válido");
                request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
                return;
            }

            // Validar y convertir valor
            double valor;
            try {
                valor = Double.parseDouble(valorStr);
                
                // Validaciones específicas por tipo
                if ("DESCUENTO_PORCENTAJE".equals(tipo)) {
                    if (valor <= 0 || valor >= 100) {
                        request.setAttribute("mensaje", "❌ Para descuento por porcentaje, el valor debe estar entre 1 y 99");
                        request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
                        return;
                    }
                } else if ("DESCUENTO_FIJO".equals(tipo)) {
                    if (valor <= 0 || valor > 1000) {
                        request.setAttribute("mensaje", "❌ Para descuento fijo, el valor debe estar entre 1 y 1000");
                        request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
                        return;
                    }
                } else {
                    // Para otros tipos, el valor puede ser 0 o positivo
                    if (valor < 0) {
                        request.setAttribute("mensaje", "❌ El valor no puede ser negativo");
                        request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
                        return;
                    }
                }
            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ Valor inválido");
                request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
                return;
            }

            // Validar y convertir fechas
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date fechaInicio, fechaFin;
            
            try {
                fechaInicio = new Date(sdf.parse(fechaInicioStr).getTime());
                fechaFin = new Date(sdf.parse(fechaFinStr).getTime());

                // Validar que fechaInicio no sea mayor que fechaFin
                if (fechaInicio.after(fechaFin)) {
                    request.setAttribute("mensaje", "❌ La fecha de inicio no puede ser posterior a la fecha fin");
                    request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
                    return;
                }

                // Validar que no sean fechas muy antiguas
                Date hoy = new Date(System.currentTimeMillis());
                if (fechaFin.before(hoy)) {
                    request.setAttribute("mensaje", "❌ La fecha fin no puede ser anterior a hoy");
                    request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
                    return;
                }

            } catch (Exception e) {
                request.setAttribute("mensaje", "❌ Formato de fecha inválido. Use YYYY-MM-DD");
                request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
                return;
            }

            // Crear promoción en la base de datos
            PromocionDao dao = new PromocionDao();
            int idPromocionCreada = dao.insertarPromocion(nombre, descripcion, tipo, valor, fechaInicio, fechaFin);

            if (idPromocionCreada > 0) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/PromocionControlador?accion=listar&creada=exito&id=" + idPromocionCreada);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al crear la promoción");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al crear promoción");
            return;
        }

        // Solo usar forward en caso de error para mostrar el mensaje en el formulario
        request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
    }

    /**
     * Lista solo las promociones activas
     */
    private void listarPromocionesActivas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            PromocionDao dao = new PromocionDao();
            List<Promocion> promociones = dao.obtenerPromocionesActivas();

            if (promociones != null && !promociones.isEmpty()) {
                request.setAttribute("promociones", promociones);
                request.setAttribute("totalPromociones", promociones.size());

                // Calcular estadísticas
                int descuentoPorcentaje = 0, descuentoFijo = 0, ofertas2x1 = 0, otros = 0;
                double valorMaximo = 0.0;

                for (Promocion promocion : promociones) {
                    switch (promocion.getTipo()) {
                        case "DESCUENTO_PORCENTAJE":
                            descuentoPorcentaje++;
                            break;
                        case "DESCUENTO_FIJO":
                            descuentoFijo++;
                            break;
                        case "2X1":
                            ofertas2x1++;
                            break;
                        default:
                            otros++;
                    }
                    
                    if (promocion.getValor() > valorMaximo) {
                        valorMaximo = promocion.getValor();
                    }
                }

                request.setAttribute("descuentoPorcentaje", descuentoPorcentaje);
                request.setAttribute("descuentoFijo", descuentoFijo);
                request.setAttribute("ofertas2x1", ofertas2x1);
                request.setAttribute("otrostipos", otros);
                request.setAttribute("valorMaximo", valorMaximo);
                request.setAttribute("mensaje", "✅ Se encontraron " + promociones.size() + " promociones activas");
            } else {
                request.setAttribute("promociones", null);
                request.setAttribute("mensaje", "ℹ️ No hay promociones activas disponibles");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar promociones activas");
            return;
        }

        request.getRequestDispatcher("PromocionesActivas.jsp").forward(request, response);
    }

    /**
     * Lista todas las promociones del sistema
     */
    private void listarTodasPromociones(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Verificar si viene de una creación exitosa
            String creada = request.getParameter("creada");
            String idCreada = request.getParameter("id");
            if ("exito".equals(creada)) {
                request.setAttribute("mensaje", "✅ Promoción creada exitosamente" + (idCreada != null ? " con ID: " + idCreada : ""));
                request.setAttribute("tipoMensaje", "exito");
            }

            PromocionDao dao = new PromocionDao();
            List<Promocion> promociones = dao.listarTodasPromociones();

            if (promociones != null && !promociones.isEmpty()) {
                request.setAttribute("promociones", promociones);
                request.setAttribute("totalPromociones", promociones.size());

                // Contar por estado
                int activas = 0, expiradas = 0, inactivas = 0;
                for (Promocion promocion : promociones) {
                    switch (promocion.getEstado()) {
                        case "ACTIVA":
                            activas++;
                            break;
                        case "EXPIRADA":
                            expiradas++;
                            break;
                        case "INACTIVA":
                            inactivas++;
                            break;
                    }
                }

                request.setAttribute("promocionesActivas", activas);
                request.setAttribute("promocionesExpiradas", expiradas);
                request.setAttribute("promocionesInactivas", inactivas);
                request.setAttribute("mensaje", "✅ Lista completa de promociones cargada");
            } else {
                request.setAttribute("promociones", null);
                request.setAttribute("mensaje", "ℹ️ No existen promociones registradas");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar todas las promociones");
            return;
        }

        request.getRequestDispatcher("ListaPromociones.jsp").forward(request, response);
    }

    /**
     * Busca promociones por diferentes criterios
     */
    private void buscarPromociones(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String termino = limpiarParametro(request.getParameter("termino"));
            String tipo = limpiarParametro(request.getParameter("tipo"));
            String estado = limpiarParametro(request.getParameter("estado"));
            String fechaInicioStr = limpiarParametro(request.getParameter("fechaInicio"));
            String fechaFinStr = limpiarParametro(request.getParameter("fechaFin"));

            PromocionDao dao = new PromocionDao();
            List<Promocion> promociones = null;

            // Conversión de fechas si se proporcionan
            Date fechaInicio = null, fechaFin = null;
            if (!fechaInicioStr.isEmpty() && !fechaFinStr.isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    fechaInicio = new Date(sdf.parse(fechaInicioStr).getTime());
                    fechaFin = new Date(sdf.parse(fechaFinStr).getTime());
                    
                    if (fechaInicio.after(fechaFin)) {
                        request.setAttribute("mensaje", "❌ La fecha de inicio no puede ser mayor que la fecha fin");
                        request.getRequestDispatcher("BuscarPromociones.jsp").forward(request, response);
                        return;
                    }
                } catch (Exception e) {
                    request.setAttribute("mensaje", "⚠️ Formato de fecha inválido, ignorando filtro por fecha");
                    fechaInicio = null;
                    fechaFin = null;
                }
            }

            // Búsqueda con criterios
            promociones = dao.buscarPromociones(termino, tipo, estado, fechaInicio, fechaFin);

            if (promociones != null && !promociones.isEmpty()) {
                request.setAttribute("promociones", promociones);
                request.setAttribute("totalPromociones", promociones.size());
                request.setAttribute("mensaje", "✅ Se encontraron " + promociones.size() + " promociones");
            } else {
                request.setAttribute("promociones", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron promociones con los criterios especificados");
            }

            // Mantener parámetros de búsqueda
            request.setAttribute("terminoBusqueda", termino);
            request.setAttribute("tipoBusqueda", tipo);
            request.setAttribute("estadoBusqueda", estado);
            request.setAttribute("fechaInicioBusqueda", fechaInicioStr);
            request.setAttribute("fechaFinBusqueda", fechaFinStr);

        } catch (Exception e) {
            manejarError(request, response, e, "Error al buscar promociones");
            return;
        }

        request.getRequestDispatcher("BuscarPromociones.jsp").forward(request, response);
    }

    /**
     * Obtiene el detalle completo de una promoción
     */
    private void obtenerDetallePromocion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idPromocionStr = limpiarParametro(request.getParameter("idPromocion"));

            if (idPromocionStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de promoción requerido");
                request.getRequestDispatcher("ListaPromociones.jsp").forward(request, response);
                return;
            }

            int idPromocion = Integer.parseInt(idPromocionStr);

            PromocionDao dao = new PromocionDao();
            Promocion promocion = dao.obtenerPromocionPorId(idPromocion);

            if (promocion != null) {
                request.setAttribute("promocionDetalle", promocion);

                // Calcular días restantes si está activa
                if ("ACTIVA".equals(promocion.getEstado())) {
                    Date hoy = new Date(System.currentTimeMillis());
                    Date fechaFin = promocion.getFechaFin();
                    
                    if (fechaFin.after(hoy)) {
                        long diferenciaMilis = fechaFin.getTime() - hoy.getTime();
                        int diasRestantes = (int) (diferenciaMilis / (1000 * 60 * 60 * 24));
                        request.setAttribute("diasRestantes", diasRestantes);
                    } else {
                        request.setAttribute("diasRestantes", 0);
                    }
                }

                // Obtener estadísticas de uso si existen
                int vecesUsada = dao.obtenerVecesUsadaPromocion(idPromocion);
                double montoAhorrado = dao.obtenerMontoAhorradoPromocion(idPromocion);
                
                request.setAttribute("vecesUsada", vecesUsada);
                request.setAttribute("montoAhorrado", montoAhorrado);
                request.setAttribute("mensaje", "✅ Detalle de promoción cargado");
            } else {
                request.setAttribute("mensaje", "❌ Promoción no encontrada");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de promoción inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al obtener detalle de promoción");
            return;
        }

        request.getRequestDispatcher("DetallePromocion.jsp").forward(request, response);
    }

    /**
     * Actualiza una promoción existente
     */
    private void actualizarPromocion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idPromocionStr = limpiarParametro(request.getParameter("idPromocion"));
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String descripcion = limpiarParametro(request.getParameter("descripcion"));
            String valorStr = limpiarParametro(request.getParameter("valor"));

            // Validaciones básicas
            if (idPromocionStr.isEmpty() || nombre.isEmpty() || descripcion.isEmpty() || valorStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID, nombre, descripción y valor son obligatorios");
                request.getRequestDispatcher("EditarPromocion.jsp").forward(request, response);
                return;
            }

            int idPromocion = Integer.parseInt(idPromocionStr);
            double valor = Double.parseDouble(valorStr);

            if (valor < 0) {
                request.setAttribute("mensaje", "❌ El valor no puede ser negativo");
                request.getRequestDispatcher("EditarPromocion.jsp").forward(request, response);
                return;
            }

            PromocionDao dao = new PromocionDao();
            boolean exito = dao.actualizarPromocion(idPromocion, nombre, descripcion, valor);

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/PromocionControlador?accion=listar&actualizada=exito&id=" + idPromocion);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al actualizar la promoción");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Datos numéricos inválidos");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al actualizar promoción");
            return;
        }

        // Solo usar forward en caso de error para mostrar el mensaje en el formulario
        request.getRequestDispatcher("EditarPromocion.jsp").forward(request, response);
    }

    /**
     * Cambia el estado de una promoción (activar/desactivar)
     */
    private void cambiarEstadoPromocion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idPromocionStr = limpiarParametro(request.getParameter("idPromocion"));
            String nuevoEstado = limpiarParametro(request.getParameter("estado"));

            if (idPromocionStr.isEmpty() || nuevoEstado.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de promoción y estado son requeridos");
                request.getRequestDispatcher("ListaPromociones.jsp").forward(request, response);
                return;
            }

            // Validar estados permitidos
            String[] estadosPermitidos = {"ACTIVA", "INACTIVA", "EXPIRADA"};
            boolean estadoValido = false;
            for (String estadoPermitido : estadosPermitidos) {
                if (estadoPermitido.equals(nuevoEstado.toUpperCase())) {
                    nuevoEstado = estadoPermitido;
                    estadoValido = true;
                    break;
                }
            }

            if (!estadoValido) {
                request.setAttribute("mensaje", "❌ Estado no válido");
                request.getRequestDispatcher("ListaPromociones.jsp").forward(request, response);
                return;
            }

            int idPromocion = Integer.parseInt(idPromocionStr);

            PromocionDao dao = new PromocionDao();
            boolean exito = dao.cambiarEstadoPromocion(idPromocion, nuevoEstado);

            if (exito) {
                String accion = "ACTIVA".equals(nuevoEstado) ? "activada" : 
                              "INACTIVA".equals(nuevoEstado) ? "desactivada" : "marcada como expirada";
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/PromocionControlador?accion=listar&estado=cambio_exito&accion_estado=" + accion);
                return;
            } else {
                // En caso de error, usar forward para mostrar el mensaje
                request.setAttribute("mensaje", "❌ Error al cambiar el estado de la promoción");
                request.setAttribute("tipoMensaje", "error");
                listarTodasPromociones(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de promoción inválido");
            listarTodasPromociones(request, response);
            return;
        } catch (Exception e) {
            manejarError(request, response, e, "Error al cambiar estado de promoción");
            return;
        }
    }

    /**
     * Elimina una promoción (marcada como inactiva)
     */
    private void eliminarPromocion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idPromocionStr = limpiarParametro(request.getParameter("idPromocion"));

            if (idPromocionStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de promoción requerido");
                request.getRequestDispatcher("ListaPromociones.jsp").forward(request, response);
                return;
            }

            int idPromocion = Integer.parseInt(idPromocionStr);

            PromocionDao dao = new PromocionDao();
            boolean exito = dao.eliminarPromocion(idPromocion);

            if (exito) {
                // ¡CORRECTO! Patrón Post-Redirect-Get para evitar duplicaciones
                response.sendRedirect(request.getContextPath() + "/PromocionControlador?accion=listar&eliminada=exito&id=" + idPromocion);
                return;
            } else {
                // En caso de error, usar forward para mostrar el mensaje
                request.setAttribute("mensaje", "❌ Error al eliminar la promoción");
                request.setAttribute("tipoMensaje", "error");
                listarTodasPromociones(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de promoción inválido");
            listarTodasPromociones(request, response);
            return;
        } catch (Exception e) {
            manejarError(request, response, e, "Error al eliminar promoción");
            return;
        }
    }

    /**
     * Valida si una promoción es aplicable para un cliente específico
     */
    private void validarPromocionParaCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idPromocionStr = limpiarParametro(request.getParameter("idPromocion"));
            String idClienteStr = limpiarParametro(request.getParameter("idCliente"));
            String montoCompraStr = limpiarParametro(request.getParameter("montoCompra"));

            if (idPromocionStr.isEmpty() || idClienteStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de promoción e ID de cliente son requeridos");
                request.getRequestDispatcher("ValidarPromocion.jsp").forward(request, response);
                return;
            }

            int idPromocion = Integer.parseInt(idPromocionStr);
            int idCliente = Integer.parseInt(idClienteStr);
            double montoCompra = 0.0;

            if (!montoCompraStr.isEmpty()) {
                montoCompra = Double.parseDouble(montoCompraStr);
            }

            PromocionDao dao = new PromocionDao();
            boolean esAplicable = dao.validarPromocionParaCliente(idPromocion, idCliente, montoCompra);

            if (esAplicable) {
                // Obtener detalles de la promoción y calcular descuento
                Promocion promocion = dao.obtenerPromocionPorId(idPromocion);
                if (promocion != null) {
                    double descuentoCalculado = dao.calcularDescuentoPromocion(promocion, montoCompra);
                    
                    request.setAttribute("promocion", promocion);
                    request.setAttribute("descuentoCalculado", descuentoCalculado);
                    request.setAttribute("montoFinal", montoCompra - descuentoCalculado);
                    request.setAttribute("mensaje", "✅ Promoción válida y aplicable");
                    request.setAttribute("esAplicable", true);
                } else {
                    request.setAttribute("mensaje", "❌ Promoción no encontrada");
                    request.setAttribute("esAplicable", false);
                }
            } else {
                request.setAttribute("mensaje", "❌ Promoción no aplicable para este cliente o compra");
                request.setAttribute("esAplicable", false);
                
                // Obtener motivo de no aplicabilidad
                String motivoRechazo = dao.obtenerMotivoRechazoPromocion(idPromocion, idCliente, montoCompra);
                request.setAttribute("motivoRechazo", motivoRechazo);
            }

            request.setAttribute("idPromocionValidada", idPromocion);
            request.setAttribute("idClienteValidado", idCliente);
            request.setAttribute("montoCompraValidado", montoCompra);

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Datos numéricos inválidos");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al validar promoción");
            return;
        }

        request.getRequestDispatcher("ValidarPromocion.jsp").forward(request, response);
    }

    /**
     * Manejo centralizado de errores
     */
    private void manejarError(HttpServletRequest request, HttpServletResponse response, 
                             Exception e, String mensajeContexto) 
            throws ServletException, IOException {
        
        System.err.println("=== ERROR EN PROMOCION CONTROLADOR ===");
        System.err.println("Contexto: " + mensajeContexto);
        System.err.println("Mensaje: " + e.getMessage());
        e.printStackTrace();

        request.setAttribute("mensaje", "❌ " + mensajeContexto + ": " + e.getMessage());
        request.setAttribute("tipoMensaje", "error");
        
        request.getRequestDispatcher("ListaPromociones.jsp").forward(request, response);
    }

    /**
     * Muestra el formulario de creación de promociones
     */
    private void mostrarFormularioCreacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Solo mostrar el formulario limpio
        request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
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
        return "Controlador para gestión completa de promociones y descuentos";
    }
}