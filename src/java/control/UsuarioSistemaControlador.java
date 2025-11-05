package control;

import dao.UsuarioSistemaDao;
import modelo.UsuarioSistema;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/UsuarioSistemaControlador"})
public class UsuarioSistemaControlador extends HttpServlet {

    // Constantes para mensajes y configuraciones
    private static final String SESSION_USUARIO = "usuarioLogueado";
    private static final String SESSION_ID = "idUsuario";
    private static final String SESSION_NOMBRE = "nombreUsuario";
    private static final String SESSION_ROL = "rolUsuario";
    private static final String SESSION_EMAIL = "emailUsuario";
    
    // CORRECCIÓN: Roles del sistema en minúsculas para coincidir con el ENUM de la BD
    private static final String ROL_ADMIN = "admin";
    private static final String ROL_VETERINARIO = "veterinario";
    private static final String ROL_RECEPCIONISTA = "recepcionista";
    private static final String ROL_GROOMER = "groomer";
    private static final String ROL_CONTADOR = "contador";
    
    // ---
    // CORRECCIÓN DE RUTAS:
    // Las páginas para 'sendRedirect' NO deben empezar con "/", ya que getContextPath() lo incluye.
    // Las vistas para 'forward' (RequestDispatcher) SÍ deben ir sin "/".
    // ---
    private static final String PAGINA_LOGIN = "Login.jsp";
    private static final String PAGINA_MENU = "Menu.jsp"; // CORREGIDO (sin /)
    private static final String PAGINA_COLA_ATENCION = "ColaAtencion.jsp"; // CORREGIDO (sin /)
    private static final String PAGINA_PROXIMAS_CITAS = "ProximasCitas.jsp"; // CORREGIDO (sin /)
    
    // (Estas vistas para 'forward' ya estaban correctas)
    private static final String VISTA_LISTA_USUARIOS = "ListaUsuarios.jsp";
    private static final String VISTA_CREAR_USUARIO = "CrearUsuario.jsp";
    private static final String VISTA_PERFIL_USUARIO = "PerfilUsuario.jsp";
    private static final String VISTA_CAMBIAR_PASS = "CambiarPassword.jsp";


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar encoding para prevenir problemas de caracteres
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");

        try {
            if (accion != null) {
                switch (accion) {
                    case "login":
                        iniciarSesion(request, response);
                        break;
                    case "logout":
                        cerrarSesion(request, response);
                        break;
                    case "registrar":
                        registrarUsuario(request, response);
                        break;
                    case "listarUsuarios":
                    case "listar":
                        listarUsuarios(request, response);
                        break;
                    case "cambiarPassword":
                        cambiarPassword(request, response);
                        break;
                    case "actualizarPerfil":
                        actualizarPerfil(request, response);
                        break;
                    case "cambiarEstado":
                        cambiarEstadoUsuario(request, response);
                        break;
                    case "buscarUsuarios":
                        buscarUsuarios(request, response);
                        break;
                    case "eliminarUsuario":
                        eliminarUsuario(request, response);
                        break;
                    case "obtenerPerfil":
                    case "mostrarPerfil":
                        obtenerPerfilUsuario(request, response);
                        break;
                    case "mostrarFormulario":
                        mostrarFormularioCreacion(request, response);
                        break;
                    default:
                        redirigirSegunSesion(request, response);
                }
            } else {
                redirigirSegunSesion(request, response);
            }
        } catch (Exception e) {
            manejarErrorGeneral(request, response, e, "Error general en el controlador de usuarios");
        }
    }

    /**
     * Maneja el inicio de sesión de usuarios con validaciones mejoradas
     */
    private void iniciarSesion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = limpiarParametro(request.getParameter("email"));
            String password = limpiarParametro(request.getParameter("password"));
            String recordarSesion = request.getParameter("recordarSesion");

            // --- INICIO DE DEPURACIÓN ---
            System.out.println("--- DEBUG LOGIN ---");
            System.out.println("1. Email recibido: [" + email + "]");
            System.out.println("2. Password recibido: [" + password + "]");
            // --- FIN DE DEPURACIÓN ---

            if (!validarCamposLogin(email, password, request, response)) {
                return;
            }

            String passwordHash = encriptarPassword(password);

            // --- INICIO DE DEPURACIÓN ---
            System.out.println("3. Hash generado: [" + passwordHash + "]");
            // --- FIN DE DEPURACIÓN ---
            
            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            UsuarioSistema usuario = dao.validarUsuario(email, passwordHash);

            if (usuario != null) {
                
                // --- Verificación de Seguridad CRÍTICA ---
                // (Esta lógica está correcta y es la que debe estar activa)
                if (!"ACTIVO".equalsIgnoreCase(usuario.getEstado())) {
                    dao.registrarIntentoFallidoLogin(email);
                    request.setAttribute("emailIntentado", email);
                    manejarErrorVista(request, response, PAGINA_LOGIN, "❌ Esta cuenta de usuario está inactiva.");
                    return;
                }
                // --- Fin de la verificación ---

                establecerSesionUsuario(request, usuario, recordarSesion);
                dao.registrarUltimoAcceso(usuario.getIdUsuario());
                redirigirSegunRol(response, usuario.getRol(), request);
                
            } else {
                // Si usuario es null, es porque el DAO no encontró
                // coincidencia entre el hash de "admin" (8c69...) y el hash de la BD.
                // Si la BD está correcta, esto solo puede pasar si el DAO o este
                // controlador no están actualizados en el servidor (Clean and Build).
                
                // CORRECCIÓN DE TIPO: El método se llama 'Intento', no 'Intanto'
                dao.registrarIntentoFallidoLogin(email); 
                
                request.setAttribute("emailIntentado", email);
                manejarErrorVista(request, response, PAGINA_LOGIN, "❌ Credenciales incorrectas");
            }

        } catch (NoSuchAlgorithmException e) {
            manejarErrorVista(request, response, PAGINA_LOGIN, "❌ Error de seguridad en el sistema");
        } catch (Exception e) {
            manejarErrorGeneral(request, response, e, "Error al iniciar sesión");
        }
    }
    
    // CORRECCIÓN: Nombre de método que estaba mal escrito en el 'else' de 'iniciarSesion'
    // CORRECCIÓN: Arreglado el tipo en el nombre de este método también
    private void registrarIntentoFallidoLogin(String email) {
        UsuarioSistemaDao dao = new UsuarioSistemaDao();
        dao.registrarIntentoFallidoLogin(email);
    }

    /**
     * Valida los campos de login
     */
    private boolean validarCamposLogin(String email, String password, 
                                       HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (email.isEmpty() || password.isEmpty()) {
            manejarErrorVista(request, response, PAGINA_LOGIN, "❌ Email y contraseña son obligatorios");
            return false;
        }
        if (!esEmailValido(email)) {
            manejarErrorVista(request, response, PAGINA_LOGIN, "❌ Formato de email inválido");
            return false;
        }
        if (password.length() < 4) {
            manejarErrorVista(request, response, PAGINA_LOGIN, "❌ La contraseña debe tener al menos 4 caracteres");
            return false;
        }
        return true;
    }

    /**
     * Establece la sesión del usuario con configuraciones de seguridad
     */
    private void establecerSesionUsuario(HttpServletRequest request, UsuarioSistema usuario, String recordarSesion) {
        HttpSession session = request.getSession(true);
        
        session.setAttribute(SESSION_USUARIO, usuario);
        session.setAttribute(SESSION_ID, usuario.getIdUsuario());
        session.setAttribute(SESSION_NOMBRE, usuario.getNombre());
        session.setAttribute(SESSION_ROL, usuario.getRol());
        session.setAttribute(SESSION_EMAIL, usuario.getEmail());

        if ("on".equals(recordarSesion)) {
            session.setMaxInactiveInterval(30 * 24 * 60 * 60); // 30 días
        } else {
            session.setMaxInactiveInterval(8 * 60 * 60); // 8 horas (jornada laboral)
        }
    }

    /**
     * Redirige a la página principal según el rol del usuario
     * CORRECCIÓN: Usa las constantes de página (ahora sin /)
     */
    private void redirigirSegunRol(HttpServletResponse response, String rol, HttpServletRequest request) 
            throws IOException {
        String targetPage = PAGINA_MENU;
        
        if (rol != null) {
            switch (rol.toLowerCase()) { 
                case ROL_ADMIN:
                    targetPage = PAGINA_MENU; // Usa constante
                    break;
                case ROL_VETERINARIO:
                    targetPage = PAGINA_COLA_ATENCION;
                    break;
                case ROL_RECEPCIONISTA:
                    targetPage = PAGINA_PROXIMAS_CITAS;
                    break;
                case ROL_GROOMER:
                    targetPage = PAGINA_MENU;
                    break;
                case ROL_CONTADOR:
                    targetPage = "ReporteControlador?accion=listar"; // CORREGIDO (sin /)
                    break;
                default:
                    targetPage = PAGINA_MENU;
            }
        }
        // getContextPath() añade el slash: /TuProyecto
        // targetPage añade el JSP: Menu.jsp
        // Resultado: /TuProyecto/Menu.jsp
        response.sendRedirect(request.getContextPath() + "/" + targetPage);
    }

    /**
     * Cierra la sesión del usuario actual con medidas de seguridad
     */
    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                UsuarioSistema usuario = (UsuarioSistema) session.getAttribute(SESSION_USUARIO);
                if (usuario != null) {
                    UsuarioSistemaDao dao = new UsuarioSistemaDao();
                    dao.registrarCierreSesion(usuario.getIdUsuario());
                }
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/" + PAGINA_LOGIN + "?mensaje=logout_exitoso");

        } catch (Exception e) {
            System.err.println("Error al cerrar sesión: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/" + PAGINA_LOGIN + "?mensaje=error_logout");
        }
    }

    /**
     * Registra un nuevo usuario en el sistema con validaciones completas
     */
    private void registrarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String email = limpiarParametro(request.getParameter("email"));
            String password = limpiarParametro(request.getParameter("password"));
            String confirmPassword = limpiarParametro(request.getParameter("confirmPassword"));
            String rolInput = limpiarParametro(request.getParameter("rol")); // Rol en minúsculas

            // Validaciones
            if (!validarRegistroUsuario(nombre, email, password, confirmPassword, rolInput, request, response)) {
                return;
            }
            
            // Validar y normalizar el rol
            String rol = validarRol(rolInput);
            if (rol == null) {
                manejarErrorVista(request, response, VISTA_CREAR_USUARIO, "❌ Rol no válido");
                return;
            }

            if (!tienePermisoAdministrador(request)) {
                manejarErrorVista(request, response, VISTA_CREAR_USUARIO, "❌ No tiene permisos para registrar usuarios");
                return;
            }

            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            
            if (dao.existeEmail(email)) {
                manejarErrorVista(request, response, VISTA_CREAR_USUARIO, "❌ El email ya está registrado");
                return;
            }

            String passwordHash = encriptarPassword(password);
            UsuarioSistema usuario = new UsuarioSistema();
            usuario.setNombre(nombre);
            usuario.setEmail(email);
            usuario.setPasswordHash(passwordHash);
            usuario.setRol(rol); // Se guarda el rol validado (minúsculas)

            int idUsuarioCreado = dao.registrarUsuarioSistema(usuario);

            if (idUsuarioCreado > 0) {
                response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=listar&creado=exito&id=" + idUsuarioCreado);
            } else {
                manejarErrorVista(request, response, VISTA_CREAR_USUARIO, "❌ Error al registrar usuario. Intente nuevamente.");
            }

        } catch (NoSuchAlgorithmException e) {
            manejarErrorVista(request, response, VISTA_CREAR_USUARIO, "❌ Error de seguridad en el sistema");
        } catch (Exception e) {
            manejarErrorVista(request, response, VISTA_CREAR_USUARIO, "❌ Error del sistema al registrar: " + e.getMessage());
        }
    }

    /**
     * Valida todos los campos del registro de usuario
     */
    private boolean validarRegistroUsuario(String nombre, String email, String password, 
                                           String confirmPassword, String rol,
                                           HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (nombre.isEmpty() || email.isEmpty() || password.isEmpty() || rol.isEmpty()) {
            manejarErrorVista(request, response, VISTA_CREAR_USUARIO, "❌ Todos los campos son obligatorios"); 
            return false; 
        }
        if (!password.equals(confirmPassword)) {
            manejarErrorVista(request, response, VISTA_CREAR_USUARIO, "❌ Las contraseñas no coinciden"); 
            return false; 
        }
        if (nombre.length() < 2 || nombre.length() > 100) {
            manejarErrorVista(request, response, VISTA_CREAR_USUARIO, "❌ El nombre debe tener entre 2 y 100 caracteres"); 
            return false; 
        }
        if (!esEmailValido(email)) {
            manejarErrorVista(request, response, VISTA_CREAR_USUARIO, "❌ Formato de email inválido"); 
            return false; 
        }
        if (!esPasswordSeguro(password)) {
            manejarErrorVista(request, response, VISTA_CREAR_USUARIO, "❌ La contraseña debe tener mínimo 8 caracteres, incluir mayúsculas, minúsculas y números"); 
            return false; 
        }
        return true;
    }

    /**
     * Verifica si el usuario actual tiene permisos de administrador
     */
    private boolean tienePermisoAdministrador(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && ROL_ADMIN.equalsIgnoreCase((String) session.getAttribute(SESSION_ROL));
    }

    /**
     * Valida y normaliza el rol del usuario (compara y devuelve en minúsculas)
     */
    private String validarRol(String rolInput) {
        if (rolInput == null || rolInput.trim().isEmpty()) {
            return null;
        }
        String rolLower = rolInput.trim().toLowerCase();
        
        String[] rolesPermitidos = {ROL_RECEPCIONISTA, ROL_ADMIN, ROL_GROOMER, ROL_CONTADOR, ROL_VETERINARIO};
        
        for (String rolPermitido : rolesPermitidos) {
            if (rolPermitido.equals(rolLower)) {
                return rolPermitido; // Devuelve el rol en minúsculas
            }
        }
        
        return null; // Rol no válido
    }

    /**
     * Lista todos los usuarios del sistema con estadísticas
     */
    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (!tienePermisoAdministrador(request)) {
                response.sendRedirect(request.getContextPath() + "/" + PAGINA_MENU + "?mensaje=permiso_denegado");
                return;
            }

            manejarMensajesAccion(request); // Maneja mensajes de éxito/error

            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            List<UsuarioSistema> usuarios = dao.listarTodosUsuarios();

            request.setAttribute("usuarios", usuarios);
            request.setAttribute("totalUsuarios", usuarios != null ? usuarios.size() : 0);

            if (usuarios != null && !usuarios.isEmpty()) {
                calcularEstadisticasUsuarios(usuarios, request);
            } else {
                if (request.getAttribute("mensaje") == null) {
                    request.setAttribute("mensaje", "ℹ️ No existen usuarios registrados");
                }
            }

        } catch (Exception e) {
            manejarErrorListado(request, e);
        }

        request.getRequestDispatcher(VISTA_LISTA_USUARIOS).forward(request, response);
    }

    /**
     * Maneja los mensajes de acciones previas (PRG pattern)
     */
    private void manejarMensajesAccion(HttpServletRequest request) {
        String creado = request.getParameter("creado");
        String actualizado = request.getParameter("actualizado");
        String eliminado = request.getParameter("eliminado");
        String idParam = request.getParameter("id");
        String warn = request.getParameter("warn");
        String error = request.getParameter("error");

        if ("exito".equals(creado)) {
            request.setAttribute("mensaje", "✅ Usuario" + (idParam != null ? " ID " + idParam : "") + " creado exitosamente.");
            request.setAttribute("tipoMensaje", "exito");
        } else if ("exito".equals(actualizado)) {
            request.setAttribute("mensaje", "✅ Usuario" + (idParam != null ? " ID " + idParam : "") + " actualizado exitosamente.");
            request.setAttribute("tipoMensaje", "exito");
        } else if ("exito".equals(eliminado)) {
            request.setAttribute("mensaje", "✅ Usuario" + (idParam != null ? " ID " + idParam : "") + " eliminado exitosamente.");
            request.setAttribute("tipoMensaje", "exito");
        }
        
        // Advertencias
        if ("auto_bloqueo_prohibido".equals(warn)) {
            request.setAttribute("mensaje", "⚠️ No puedes cambiar tu propio estado.");
            request.setAttribute("tipoMensaje", "info");
        }
        if ("auto_eliminar_prohibido".equals(warn)) {
            request.setAttribute("mensaje", "⚠️ No puedes eliminar tu propia cuenta.");
            request.setAttribute("tipoMensaje", "info");
        }
        
        // Errores
        if ("estado_fallido".equals(error)) {
            request.setAttribute("mensaje", "❌ Error al cambiar el estado del usuario " + idParam);
            request.setAttribute("tipoMensaje", "error");
        }
    }

    /**
     * Calcula estadísticas de usuarios por rol (compara en minúsculas)
     */
    private void calcularEstadisticasUsuarios(List<UsuarioSistema> usuarios, HttpServletRequest request) {
        int administradores = 0, veterinarios = 0, recepcionistas = 0, groomers = 0, contadores = 0, otros = 0;

        for (UsuarioSistema usuario : usuarios) {
            if (usuario.getRol() != null) {
                switch (usuario.getRol().toLowerCase()) { // Compara en minúsculas
                    case ROL_ADMIN: administradores++; break;
                    case ROL_VETERINARIO: veterinarios++; break;
                    case ROL_RECEPCIONISTA: recepcionistas++; break;
                    case ROL_GROOMER: groomers++; break;
                    case ROL_CONTADOR: contadores++; break;
                    default: otros++;
                }
            } else {
                otros++;
            }
        }

        request.setAttribute("administradores", administradores);
        request.setAttribute("veterinarios", veterinarios);
        request.setAttribute("recepcionistas", recepcionistas);
        request.setAttribute("groomers", groomers);
        request.setAttribute("contadores", contadores);
        request.setAttribute("otrosRoles", otros);

        if (request.getAttribute("mensaje") == null) {
            request.setAttribute("mensaje", "✅ Lista de usuarios cargada (" + usuarios.size() + ")");
        }
    }

    /**
     * Cambia la contraseña del usuario logueado
     */
    private void cambiarPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String passwordActual = limpiarParametro(request.getParameter("passwordActual"));
            String passwordNuevo = limpiarParametro(request.getParameter("passwordNuevo"));
            String confirmPasswordNuevo = limpiarParametro(request.getParameter("confirmPasswordNuevo"));

            if (!validarCambioPassword(passwordActual, passwordNuevo, confirmPasswordNuevo, request, response)) {
                return;
            }

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute(SESSION_USUARIO) == null) {
                response.sendRedirect(request.getContextPath() + "/" + PAGINA_LOGIN + "?mensaje=sesion_expirada"); 
                return; 
            }

            UsuarioSistema usuarioLogueado = (UsuarioSistema) session.getAttribute(SESSION_USUARIO);
            UsuarioSistemaDao dao = new UsuarioSistemaDao();

            String passwordActualHash = encriptarPassword(passwordActual);
            if (!dao.verificarPasswordActual(usuarioLogueado.getIdUsuario(), passwordActualHash)) {
                manejarErrorVista(request, response, VISTA_CAMBIAR_PASS, "❌ Contraseña actual incorrecta"); 
                return; 
            }

            String passwordNuevoHash = encriptarPassword(passwordNuevo);
            boolean exito = dao.cambiarPassword(usuarioLogueado.getIdUsuario(), passwordNuevoHash);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=mostrarPerfil&passwordCambiada=exito");
            } else {
                manejarErrorVista(request, response, VISTA_CAMBIAR_PASS, "❌ Error al actualizar la contraseña en la base de datos");
            }

        } catch (NoSuchAlgorithmException e) {
            manejarErrorVista(request, response, VISTA_CAMBIAR_PASS, "❌ Error de seguridad en el sistema");
        } catch (Exception e) {
            manejarErrorVista(request, response, VISTA_CAMBIAR_PASS, "❌ Error del sistema al cambiar contraseña: " + e.getMessage());
        }
    }

    /**
     * Valida el cambio de contraseña
     */
    private boolean validarCambioPassword(String passwordActual, String passwordNuevo, 
                                           String confirmPasswordNuevo,
                                           HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (passwordActual.isEmpty() || passwordNuevo.isEmpty() || confirmPasswordNuevo.isEmpty()) {
            manejarErrorVista(request, response, VISTA_CAMBIAR_PASS, "❌ Todos los campos son obligatorios"); 
            return false; 
        }
        if (!passwordNuevo.equals(confirmPasswordNuevo)) {
            manejarErrorVista(request, response, VISTA_CAMBIAR_PASS, "❌ Las contraseñas nuevas no coinciden"); 
            return false; 
        }
        if (!esPasswordSeguro(passwordNuevo)) {
            manejarErrorVista(request, response, VISTA_CAMBIAR_PASS, "❌ La contraseña nueva no cumple los requisitos de seguridad"); 
            return false; 
        }
        return true;
    }

    /**
     * Actualiza el perfil del usuario actual
     */
    private void actualizarPerfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String email = limpiarParametro(request.getParameter("email"));

            if (!validarActualizacionPerfil(nombre, email, request, response)) {
                return;
            }

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute(SESSION_USUARIO) == null) {
                response.sendRedirect(request.getContextPath() + "/" + PAGINA_LOGIN + "?mensaje=sesion_expirada"); 
                return; 
            }

            UsuarioSistema usuarioLogueado = (UsuarioSistema) session.getAttribute(SESSION_USUARIO);
            UsuarioSistemaDao dao = new UsuarioSistemaDao();

            if (!email.equalsIgnoreCase(usuarioLogueado.getEmail()) && dao.existeEmail(email)) {
                manejarErrorVista(request, response, VISTA_PERFIL_USUARIO, "❌ El nuevo email ya está registrado por otro usuario"); 
                return;
            }

            boolean exito = dao.actualizarPerfil(usuarioLogueado.getIdUsuario(), nombre, email);

            if (exito) {
                actualizarSesionUsuario(session, usuarioLogueado, nombre, email);
                response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=mostrarPerfil&actualizado=exito");
            } else {
                manejarErrorVista(request, response, VISTA_PERFIL_USUARIO, "❌ Error al actualizar el perfil en la base de datos");
            }

        } catch (Exception e) {
            manejarErrorVista(request, response, VISTA_PERFIL_USUARIO, "❌ Error del sistema al actualizar perfil: " + e.getMessage());
        }
    }

    /**
     * Valida la actualización del perfil
     */
    private boolean validarActualizacionPerfil(String nombre, String email,
                                               HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (nombre.isEmpty() || email.isEmpty()) {
            manejarErrorVista(request, response, VISTA_PERFIL_USUARIO, "❌ Nombre y email son obligatorios"); 
            return false; 
        }
        if (nombre.length() < 2 || nombre.length() > 100) {
            manejarErrorVista(request, response, VISTA_PERFIL_USUARIO, "❌ El nombre debe tener entre 2 y 100 caracteres"); 
            return false; 
        }
        if (!esEmailValido(email)) {
            manejarErrorVista(request, response, VISTA_PERFIL_USUARIO, "❌ Formato de email inválido"); 
            return false; 
        }
        return true;
    }

    /**
     * Actualiza los datos del usuario en la sesión
     */
    private void actualizarSesionUsuario(HttpSession session, UsuarioSistema usuario, String nombre, String email) {
        usuario.setNombre(nombre);
        usuario.setEmail(email);
        session.setAttribute(SESSION_USUARIO, usuario);
        session.setAttribute(SESSION_NOMBRE, nombre);
        session.setAttribute(SESSION_EMAIL, email);
    }
    
    /**
     * Método 'buscarUsuarios' actualizado (pasa 'estado' al DAO)
     */
    private void buscarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (!tienePermisoAdministrador(request)) {
                response.sendRedirect(request.getContextPath() + "/" + PAGINA_MENU + "?mensaje=permiso_denegado");
                return;
            }

            String termino = limpiarParametro(request.getParameter("terminoBusqueda"));
            String rol = limpiarParametro(request.getParameter("filtroRol"));
            String estado = limpiarParametro(request.getParameter("filtroEstado")); // Campo para filtrar

            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            List<UsuarioSistema> usuarios = dao.buscarUsuarios(termino, rol, estado); 

            request.setAttribute("usuarios", usuarios);
            request.setAttribute("totalUsuarios", usuarios.size());
            
            request.setAttribute("terminoPrevio", termino);
            request.setAttribute("rolPrevio", rol);
            request.setAttribute("estadoPrevio", estado);

            if (usuarios.isEmpty()) {
                request.setAttribute("mensaje", "ℹ️ No se encontraron usuarios con esos criterios.");
            } else {
                request.setAttribute("mensaje", "✅ Se encontraron " + usuarios.size() + " usuarios.");
            }
            
            calcularEstadisticasUsuarios(usuarios, request);

        } catch (Exception e) {
            manejarErrorListado(request, e);
        }

        request.getRequestDispatcher(VISTA_LISTA_USUARIOS).forward(request, response);
    }

    /**
     * Método para implementar 'case "cambiarEstado"'
     */
    private void cambiarEstadoUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!tienePermisoAdministrador(request)) {
            response.sendRedirect(request.getContextPath() + "/" + PAGINA_MENU + "?mensaje=permiso_denegado");
            return;
        }
        
        try {
            int idUsuario = Integer.parseInt(request.getParameter("id"));
            String nuevoEstado = limpiarParametro(request.getParameter("estado")); // "ACTIVO" o "INACTIVO"

            if (!"ACTIVO".equals(nuevoEstado) && !"INACTIVO".equals(nuevoEstado)) {
                manejarAdvertencia(request, response, "estado_invalido");
                return;
            }
            
            HttpSession session = request.getSession(false);
            int idUsuarioLogueado = (Integer) session.getAttribute(SESSION_ID);
            
            if (idUsuario == idUsuarioLogueado) {
                 manejarAdvertencia(request, response, "auto_bloqueo_prohibido");
                 return;
            }

            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            boolean exito = dao.cambiarEstadoUsuario(idUsuario, nuevoEstado);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=listar&actualizado=exito&id=" + idUsuario);
            } else {
                response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=listar&error=estado_fallido&id=" + idUsuario);
            }
            
        } catch (NumberFormatException e) {
             response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=listar&error=id_invalido");
        } catch (Exception e) {
            manejarErrorGeneral(request, response, e, "Error al cambiar estado");
        }
    }
    
    /**
     * Método para implementar 'case "eliminarUsuario"'
     */
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!tienePermisoAdministrador(request)) {
            response.sendRedirect(request.getContextPath() + "/" + PAGINA_MENU + "?mensaje=permiso_denegado");
            return;
        }

        try {
            int idUsuario = Integer.parseInt(request.getParameter("id"));

            HttpSession session = request.getSession(false);
            int idUsuarioLogueado = (Integer) session.getAttribute(SESSION_ID);

            if (idUsuario == idUsuarioLogueado) {
                manejarAdvertencia(request, response, "auto_eliminar_prohibido");
                return;
            }

            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            boolean exito = dao.eliminarUsuario(idUsuario);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=listar&eliminado=exito&id=" + idUsuario);
            } else {
                response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=listar&error=eliminar_fallido&id=" + idUsuario);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=listar&error=id_invalido");
        } catch (Exception e) {
            if (e.getMessage().contains("ConstraintViolationException")) {
                 response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=listar&error=usuario_con_registros");
            } else {
                 manejarErrorGeneral(request, response, e, "Error al eliminar usuario");
            }
        }
    }
    
    /**
     * Método para implementar 'case "obtenerPerfilUsuario"'
     */
    private void obtenerPerfilUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(SESSION_USUARIO) == null) {
            response.sendRedirect(request.getContextPath() + "/" + PAGINA_LOGIN + "?mensaje=sesion_expirada"); 
            return; 
        }

        try {
            if ("exito".equals(request.getParameter("passwordCambiada"))) {
                request.setAttribute("mensaje", "✅ Contraseña actualizada exitosamente.");
                request.setAttribute("tipoMensaje", "exito");
            }
            if ("exito".equals(request.getParameter("actualizado"))) {
                request.setAttribute("mensaje", "✅ Perfil actualizado exitosamente.");
                request.setAttribute("tipoMensaje", "exito");
            }

            int idUsuarioLogueado = (Integer) session.getAttribute(SESSION_ID);
            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            UsuarioSistema usuario = dao.obtenerPerfilCompleto(idUsuarioLogueado);

            if (usuario != null) {
                request.setAttribute("usuarioPerfil", usuario);
                request.getRequestDispatcher(VISTA_PERFIL_USUARIO).forward(request, response);
            } else {
                cerrarSesion(request, response);
            }
        } catch (Exception e) {
             manejarErrorGeneral(request, response, e, "Error al obtener perfil");
        }
    }
    
    /**
     * Método para implementar 'case "mostrarFormularioCreacion"'
     */
    private void mostrarFormularioCreacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!tienePermisoAdministrador(request)) {
            response.sendRedirect(request.getContextPath() + "/" + PAGINA_MENU + "?mensaje=permiso_denegado");
            return;
        }
        
        request.getRequestDispatcher(VISTA_CREAR_USUARIO).forward(request, response);
    }


    // --- MÉTODOS DE UTILIDAD Y MANEJO DE ERRORES ---

    /**
     * Valida formato de email con expresión regular (RFC 5322 simple)
     */
    private boolean esEmailValido(String email) {
        if (email == null) return false;
        String emailPattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        return Pattern.matches(emailPattern, email);
    }

    /**
     * Validar fortaleza de contraseña (para registro y cambio)
     */
    private boolean esPasswordSeguro(String password) {
        if (password == null) return false;
        // Mínimo 8 caracteres, 1 mayúscula, 1 minúscula, 1 número
        return password.length() >= 8 &&
               password.matches(".*[A-Z].*") &&
               password.matches(".*[a-z].*") &&
               password.matches(".*\\d.*");
    }

    /**
     * Encriptar contraseña usando SHA-256 (Compatible con Java 8)
     */
    private String encriptarPassword(String password) throws NoSuchAlgorithmException {
        if (password == null) {
            throw new IllegalArgumentException("La contraseña no puede ser nula");
        }
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashedPassword = md.digest(password.getBytes(java.nio.charset.StandardCharsets.UTF_8));

        StringBuilder sb = new StringBuilder(hashedPassword.length * 2);
        for (byte b : hashedPassword) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    /**
     * Manejo de errores que deben devolver al usuario a una VISTA específica (forward)
     */
    private void manejarErrorVista(HttpServletRequest request, HttpServletResponse response,
                                   String vista, String mensaje)
            throws ServletException, IOException {
        System.err.println("Error en Controlador Usuario: " + mensaje);
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipoMensaje", "error");
        
        if (VISTA_CREAR_USUARIO.equals(vista)) {
            request.setAttribute("nombrePrevio", request.getParameter("nombre"));
            request.setAttribute("emailPrevio", request.getParameter("email"));
            request.setAttribute("rolPrevio", request.getParameter("rol"));
        }
        if(VISTA_PERFIL_USUARIO.equals(vista)) {
            // Recargar datos para la vista de perfil
            try {
                HttpSession session = request.getSession(false);
                if (session != null) {
                    int idUsuarioLogueado = (Integer) session.getAttribute(SESSION_ID);
                    UsuarioSistemaDao dao = new UsuarioSistemaDao();
                    UsuarioSistema usuario = dao.obtenerPerfilCompleto(idUsuarioLogueado);
                    request.setAttribute("usuarioPerfil", usuario);
                }
            } catch (Exception e) {
                System.err.println("Error anidado al recargar perfil: " + e.getMessage());
            }
        }
        
        request.getRequestDispatcher(vista).forward(request, response);
    }

    /**
     * Manejo centralizado de errores GENERALES del sistema (redirect)
     */
    private void manejarErrorGeneral(HttpServletRequest request, HttpServletResponse response,
                                   Exception e, String mensajeContexto)
            throws ServletException, IOException {

        System.err.println("=== ERROR GRAVE EN USUARIO SISTEMA CONTROLADOR ===");
        System.err.println("Contexto: " + mensajeContexto);
        System.err.println("Mensaje Excepción: " + e.getMessage());
        e.printStackTrace();

        response.sendRedirect(request.getContextPath() + "/" + PAGINA_LOGIN + "?mensaje=error_inesperado");
    }

    /**
     * Método auxiliar para limpiar parámetros de entrada
     */
    private String limpiarParametro(String param) {
        if (param == null) {
            return "";
        }
        return param.trim();
    }

    /**
     * Redirige según el estado de la sesión (si no hay acción)
     */
    private void redirigirSegunSesion(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute(SESSION_USUARIO) != null) {
            response.sendRedirect(request.getContextPath() + "/" + PAGINA_MENU);
        } else {
            response.sendRedirect(PAGINA_LOGIN); // Redirige a Login.jsp
        }
    }

    // Métodos auxiliares para manejo de advertencias (redirect)
    private void manejarAdvertencia(HttpServletRequest request, HttpServletResponse response, String tipo) 
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=listar&warn=" + tipo);
    }

    private void manejarErrorListado(HttpServletRequest request, Exception e) {
        System.err.println("Error grave al listar usuarios: " + e.getMessage());
        e.printStackTrace();
        request.setAttribute("mensaje", "❌ Error crítico al cargar la lista de usuarios.");
        request.setAttribute("tipoMensaje", "error");
        request.setAttribute("usuarios", new ArrayList<UsuarioSistema>());
        request.setAttribute("totalUsuarios", 0);
    }

    // --- Métodos estándar de HttpServlet ---
    
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
        return "Controlador para gestión completa de usuarios del sistema";
    }
}