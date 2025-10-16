package control;

import dao.UsuarioSistemaDao;
import modelo.UsuarioSistema;
import java.io.IOException;
import java.security.MessageDigest;
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

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar encoding
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
                        obtenerPerfilUsuario(request, response);
                        break;
                    default:
                        response.sendRedirect("Login.jsp");
                }
            } else {
                response.sendRedirect("Login.jsp");
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error general en el controlador de usuarios");
        }
    }

    /**
     * Maneja el inicio de sesión de usuarios
     */
    private void iniciarSesion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener parámetros
            String email = limpiarParametro(request.getParameter("email"));
            String password = limpiarParametro(request.getParameter("password"));
            String recordarSesion = request.getParameter("recordarSesion");

            // Validaciones básicas
            if (email.isEmpty() || password.isEmpty()) {
                request.setAttribute("mensaje", "❌ Email y contraseña son obligatorios");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
                return;
            }

            // Validar formato de email
            if (!esEmailValido(email)) {
                request.setAttribute("mensaje", "❌ Formato de email inválido");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
                return;
            }

            // Encriptar password para verificación
            String passwordHash = encriptarPassword(password);

            // Validar credenciales
            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            UsuarioSistema usuario = dao.validarUsuario(email, passwordHash);

            if (usuario != null) {
                // Verificar que el usuario esté activo
                if (!"ACTIVO".equals(usuario.getEstado())) {
                    request.setAttribute("mensaje", "❌ Usuario inactivo. Contacte al administrador");
                    request.getRequestDispatcher("Login.jsp").forward(request, response);
                    return;
                }

                // Crear sesión
                HttpSession session = request.getSession(true);
                session.setAttribute("usuarioLogueado", usuario);
                session.setAttribute("idUsuario", usuario.getIdUsuario());
                session.setAttribute("nombreUsuario", usuario.getNombre());
                session.setAttribute("rolUsuario", usuario.getRol());
                session.setAttribute("emailUsuario", usuario.getEmail());

                // Configurar tiempo de sesión
                if ("on".equals(recordarSesion)) {
                    session.setMaxInactiveInterval(30 * 24 * 60 * 60); // 30 días
                } else {
                    session.setMaxInactiveInterval(8 * 60 * 60); // 8 horas
                }

                // Registrar último acceso
                dao.registrarUltimoAcceso(usuario.getIdUsuario());

                // Redirigir según rol
                switch (usuario.getRol()) {
                    case "ADMINISTRADOR":
                        response.sendRedirect("Menu.jsp");
                        break;
                    case "VETERINARIO":
                        response.sendRedirect("ColaAtencion.jsp");
                        break;
                    case "RECEPCIONISTA":
                        response.sendRedirect("ProximasCitas.jsp");
                        break;
                    default:
                        response.sendRedirect("Menu.jsp");
                }

            } else {
                // Registrar intento fallido
                dao.registrarIntentoFallidoLogin(email);
                
                request.setAttribute("mensaje", "❌ Credenciales incorrectas");
                request.setAttribute("emailIntentado", email);
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al iniciar sesión");
        }
    }

    /**
     * Cierra la sesión del usuario actual
     */
    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            
            if (session != null) {
                // Obtener información del usuario antes de destruir la sesión
                UsuarioSistema usuario = (UsuarioSistema) session.getAttribute("usuarioLogueado");
                
                if (usuario != null) {
                    // Registrar cierre de sesión
                    UsuarioSistemaDao dao = new UsuarioSistemaDao();
                    dao.registrarCierreSesion(usuario.getIdUsuario());
                }

                // Invalidar sesión
                session.invalidate();
            }

            // Redirigir al login
            response.sendRedirect("Login.jsp?mensaje=✅ Sesión cerrada exitosamente");

        } catch (Exception e) {
            // En caso de error, forzar redirección al login
            response.sendRedirect("Login.jsp?mensaje=⚠️ Error al cerrar sesión");
        }
    }

    /**
     * Registra un nuevo usuario en el sistema
     */
    private void registrarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener parámetros
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String email = limpiarParametro(request.getParameter("email"));
            String password = limpiarParametro(request.getParameter("password"));
            String confirmPassword = limpiarParametro(request.getParameter("confirmPassword"));
            String rol = limpiarParametro(request.getParameter("rol"));

            // Validaciones básicas
            if (nombre.isEmpty() || email.isEmpty() || password.isEmpty() || rol.isEmpty()) {
                request.setAttribute("mensaje", "❌ Todos los campos son obligatorios");
                request.getRequestDispatcher("RegistrarUsuario.jsp").forward(request, response);
                return;
            }

            // Validar confirmación de contraseña
            if (!password.equals(confirmPassword)) {
                request.setAttribute("mensaje", "❌ Las contraseñas no coinciden");
                request.getRequestDispatcher("RegistrarUsuario.jsp").forward(request, response);
                return;
            }

            // Validar longitud del nombre
            if (nombre.length() < 2 || nombre.length() > 100) {
                request.setAttribute("mensaje", "❌ El nombre debe tener entre 2 y 100 caracteres");
                request.getRequestDispatcher("RegistrarUsuario.jsp").forward(request, response);
                return;
            }

            // Validar formato de email
            if (!esEmailValido(email)) {
                request.setAttribute("mensaje", "❌ Formato de email inválido");
                request.getRequestDispatcher("RegistrarUsuario.jsp").forward(request, response);
                return;
            }

            // Validar fortaleza de contraseña
            if (!esPasswordSeguro(password)) {
                request.setAttribute("mensaje", "❌ La contraseña debe tener al menos 8 caracteres, incluyendo mayúsculas, minúsculas y números");
                request.getRequestDispatcher("RegistrarUsuario.jsp").forward(request, response);
                return;
            }

            // Validar roles permitidos
            String[] rolesPermitidos = {"ADMINISTRADOR", "VETERINARIO", "RECEPCIONISTA", "ASISTENTE"};
            boolean rolValido = false;
            for (String rolPermitido : rolesPermitidos) {
                if (rolPermitido.equals(rol.toUpperCase())) {
                    rol = rolPermitido;
                    rolValido = true;
                    break;
                }
            }

            if (!rolValido) {
                request.setAttribute("mensaje", "❌ Rol no válido");
                request.getRequestDispatcher("RegistrarUsuario.jsp").forward(request, response);
                return;
            }

            // Verificar permisos (solo administradores pueden registrar usuarios)
            HttpSession session = request.getSession(false);
            if (session == null || !"ADMINISTRADOR".equals(session.getAttribute("rolUsuario"))) {
                request.setAttribute("mensaje", "❌ No tiene permisos para registrar usuarios");
                request.getRequestDispatcher("RegistrarUsuario.jsp").forward(request, response);
                return;
            }

            // Encriptar contraseña
            String passwordHash = encriptarPassword(password);

            // Crear objeto usuario
            UsuarioSistema usuario = new UsuarioSistema();
            usuario.setNombre(nombre);
            usuario.setEmail(email);
            usuario.setPasswordHash(passwordHash);
            usuario.setRol(rol);

            // Registrar usuario
            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            int idUsuarioCreado = dao.registrarUsuarioSistema(usuario);

            if (idUsuarioCreado > 0) {
                request.setAttribute("mensaje", "✅ Usuario registrado exitosamente con ID: " + idUsuarioCreado);
                request.setAttribute("tipoMensaje", "success");
                
                // Limpiar formulario
                request.removeAttribute("nombre");
                request.removeAttribute("email");
                request.removeAttribute("rol");
            } else {
                request.setAttribute("mensaje", "❌ Error al registrar usuario. Posiblemente el email ya existe");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al registrar usuario");
            return;
        }

        request.getRequestDispatcher("RegistrarUsuario.jsp").forward(request, response);
    }

    /**
     * Lista todos los usuarios del sistema
     */
    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Verificar permisos
            HttpSession session = request.getSession(false);
            if (session == null || !"ADMINISTRADOR".equals(session.getAttribute("rolUsuario"))) {
                request.setAttribute("mensaje", "❌ No tiene permisos para ver la lista de usuarios");
                response.sendRedirect("Menu.jsp");
                return;
            }

            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            List<UsuarioSistema> usuarios = dao.listarTodosUsuarios();

            if (usuarios != null && !usuarios.isEmpty()) {
                request.setAttribute("usuarios", usuarios);
                request.setAttribute("totalUsuarios", usuarios.size());

                // Estadísticas por rol
                int administradores = 0, veterinarios = 0, recepcionistas = 0, otros = 0;
                int activos = 0, inactivos = 0;

                for (UsuarioSistema usuario : usuarios) {
                    switch (usuario.getRol()) {
                        case "ADMINISTRADOR":
                            administradores++;
                            break;
                        case "VETERINARIO":
                            veterinarios++;
                            break;
                        case "RECEPCIONISTA":
                            recepcionistas++;
                            break;
                        default:
                            otros++;
                    }

                    if ("ACTIVO".equals(usuario.getEstado())) {
                        activos++;
                    } else {
                        inactivos++;
                    }
                }

                request.setAttribute("administradores", administradores);
                request.setAttribute("veterinarios", veterinarios);
                request.setAttribute("recepcionistas", recepcionistas);
                request.setAttribute("otrosRoles", otros);
                request.setAttribute("usuariosActivos", activos);
                request.setAttribute("usuariosInactivos", inactivos);
                request.setAttribute("mensaje", "✅ Lista de usuarios cargada");
            } else {
                request.setAttribute("usuarios", null);
                request.setAttribute("mensaje", "ℹ️ No existen usuarios registrados");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar usuarios");
            return;
        }

        request.getRequestDispatcher("ListaUsuarios.jsp").forward(request, response);
    }

    /**
     * Cambia la contraseña de un usuario
     */
    private void cambiarPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String passwordActual = limpiarParametro(request.getParameter("passwordActual"));
            String passwordNuevo = limpiarParametro(request.getParameter("passwordNuevo"));
            String confirmPasswordNuevo = limpiarParametro(request.getParameter("confirmPasswordNuevo"));

            // Validaciones básicas
            if (passwordActual.isEmpty() || passwordNuevo.isEmpty() || confirmPasswordNuevo.isEmpty()) {
                request.setAttribute("mensaje", "❌ Todos los campos son obligatorios");
                request.getRequestDispatcher("CambiarPassword.jsp").forward(request, response);
                return;
            }

            if (!passwordNuevo.equals(confirmPasswordNuevo)) {
                request.setAttribute("mensaje", "❌ Las contraseñas nuevas no coinciden");
                request.getRequestDispatcher("CambiarPassword.jsp").forward(request, response);
                return;
            }

            if (!esPasswordSeguro(passwordNuevo)) {
                request.setAttribute("mensaje", "❌ La contraseña nueva no cumple con los requisitos de seguridad");
                request.getRequestDispatcher("CambiarPassword.jsp").forward(request, response);
                return;
            }

            // Verificar sesión
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect("Login.jsp");
                return;
            }

            UsuarioSistema usuarioLogueado = (UsuarioSistema) session.getAttribute("usuarioLogueado");
            if (usuarioLogueado == null) {
                response.sendRedirect("Login.jsp");
                return;
            }

            // Verificar contraseña actual
            String passwordActualHash = encriptarPassword(passwordActual);
            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            
            if (!dao.verificarPasswordActual(usuarioLogueado.getIdUsuario(), passwordActualHash)) {
                request.setAttribute("mensaje", "❌ Contraseña actual incorrecta");
                request.getRequestDispatcher("CambiarPassword.jsp").forward(request, response);
                return;
            }

            // Cambiar contraseña
            String passwordNuevoHash = encriptarPassword(passwordNuevo);
            boolean exito = dao.cambiarPassword(usuarioLogueado.getIdUsuario(), passwordNuevoHash);

            if (exito) {
                request.setAttribute("mensaje", "✅ Contraseña cambiada exitosamente");
                request.setAttribute("tipoMensaje", "success");
            } else {
                request.setAttribute("mensaje", "❌ Error al cambiar la contraseña");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al cambiar contraseña");
            return;
        }

        request.getRequestDispatcher("CambiarPassword.jsp").forward(request, response);
    }

    /**
     * Actualiza el perfil del usuario actual
     */
    private void actualizarPerfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String email = limpiarParametro(request.getParameter("email"));

            // Validaciones
            if (nombre.isEmpty() || email.isEmpty()) {
                request.setAttribute("mensaje", "❌ Nombre y email son obligatorios");
                request.getRequestDispatcher("PerfilUsuario.jsp").forward(request, response);
                return;
            }

            if (!esEmailValido(email)) {
                request.setAttribute("mensaje", "❌ Formato de email inválido");
                request.getRequestDispatcher("PerfilUsuario.jsp").forward(request, response);
                return;
            }

            // Verificar sesión
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect("Login.jsp");
                return;
            }

            UsuarioSistema usuarioLogueado = (UsuarioSistema) session.getAttribute("usuarioLogueado");
            if (usuarioLogueado == null) {
                response.sendRedirect("Login.jsp");
                return;
            }

            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            boolean exito = dao.actualizarPerfil(usuarioLogueado.getIdUsuario(), nombre, email);

            if (exito) {
                // Actualizar datos en la sesión
                usuarioLogueado.setNombre(nombre);
                usuarioLogueado.setEmail(email);
                session.setAttribute("usuarioLogueado", usuarioLogueado);
                session.setAttribute("nombreUsuario", nombre);
                session.setAttribute("emailUsuario", email);

                request.setAttribute("mensaje", "✅ Perfil actualizado exitosamente");
                request.setAttribute("tipoMensaje", "success");
            } else {
                request.setAttribute("mensaje", "❌ Error al actualizar el perfil");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al actualizar perfil");
            return;
        }

        request.getRequestDispatcher("PerfilUsuario.jsp").forward(request, response);
    }

    /**
     * Cambia el estado de un usuario (solo administradores)
     */
    private void cambiarEstadoUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Verificar permisos
            HttpSession session = request.getSession(false);
            if (session == null || !"ADMINISTRADOR".equals(session.getAttribute("rolUsuario"))) {
                request.setAttribute("mensaje", "❌ No tiene permisos para cambiar estados de usuarios");
                response.sendRedirect("Menu.jsp");
                return;
            }

            String idUsuarioStr = limpiarParametro(request.getParameter("idUsuario"));
            String nuevoEstado = limpiarParametro(request.getParameter("estado"));

            if (idUsuarioStr.isEmpty() || nuevoEstado.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de usuario y estado son requeridos");
                listarUsuarios(request, response);
                return;
            }

            int idUsuario = Integer.parseInt(idUsuarioStr);
            
            // Validar que no se desactive a sí mismo
            Integer idUsuarioLogueado = (Integer) session.getAttribute("idUsuario");
            if (idUsuario == idUsuarioLogueado && "INACTIVO".equals(nuevoEstado)) {
                request.setAttribute("mensaje", "❌ No puede desactivar su propia cuenta");
                listarUsuarios(request, response);
                return;
            }

            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            boolean exito = dao.cambiarEstadoUsuario(idUsuario, nuevoEstado);

            if (exito) {
                String accion = "ACTIVO".equals(nuevoEstado) ? "activado" : "desactivado";
                request.setAttribute("mensaje", "✅ Usuario " + accion + " exitosamente");
                request.setAttribute("tipoMensaje", "success");
            } else {
                request.setAttribute("mensaje", "❌ Error al cambiar el estado del usuario");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de usuario inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al cambiar estado de usuario");
            return;
        }

        listarUsuarios(request, response);
    }

    /**
     * Busca usuarios por diferentes criterios
     */
    private void buscarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Verificar permisos
            HttpSession session = request.getSession(false);
            if (session == null || !"ADMINISTRADOR".equals(session.getAttribute("rolUsuario"))) {
                request.setAttribute("mensaje", "❌ No tiene permisos para buscar usuarios");
                response.sendRedirect("Menu.jsp");
                return;
            }

            String termino = limpiarParametro(request.getParameter("termino"));
            String rol = limpiarParametro(request.getParameter("rol"));
            String estado = limpiarParametro(request.getParameter("estado"));

            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            List<UsuarioSistema> usuarios = dao.buscarUsuarios(termino, rol, estado);

            if (usuarios != null && !usuarios.isEmpty()) {
                request.setAttribute("usuarios", usuarios);
                request.setAttribute("totalUsuarios", usuarios.size());
                request.setAttribute("mensaje", "✅ Se encontraron " + usuarios.size() + " usuarios");
            } else {
                request.setAttribute("usuarios", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron usuarios con los criterios especificados");
            }

            // Mantener parámetros de búsqueda
            request.setAttribute("terminoBusqueda", termino);
            request.setAttribute("rolBusqueda", rol);
            request.setAttribute("estadoBusqueda", estado);

        } catch (Exception e) {
            manejarError(request, response, e, "Error al buscar usuarios");
            return;
        }

        request.getRequestDispatcher("BuscarUsuarios.jsp").forward(request, response);
    }

    /**
     * Obtiene el perfil completo del usuario actual
     */
    private void obtenerPerfilUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect("Login.jsp");
                return;
            }

            UsuarioSistema usuarioLogueado = (UsuarioSistema) session.getAttribute("usuarioLogueado");
            if (usuarioLogueado == null) {
                response.sendRedirect("Login.jsp");
                return;
            }

            // Obtener información adicional del perfil
            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            UsuarioSistema perfilCompleto = dao.obtenerPerfilCompleto(usuarioLogueado.getIdUsuario());

            if (perfilCompleto != null) {
                request.setAttribute("perfilUsuario", perfilCompleto);
                request.setAttribute("mensaje", "✅ Perfil cargado correctamente");
            } else {
                request.setAttribute("mensaje", "❌ Error al cargar el perfil");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al obtener perfil de usuario");
            return;
        }

        request.getRequestDispatcher("PerfilUsuario.jsp").forward(request, response);
    }

    /**
     * Elimina un usuario del sistema (solo administradores)
     */
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Verificar permisos
            HttpSession session = request.getSession(false);
            if (session == null || !"ADMINISTRADOR".equals(session.getAttribute("rolUsuario"))) {
                request.setAttribute("mensaje", "❌ No tiene permisos para eliminar usuarios");
                response.sendRedirect("Menu.jsp");
                return;
            }

            String idUsuarioStr = limpiarParametro(request.getParameter("idUsuario"));

            if (idUsuarioStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de usuario requerido");
                listarUsuarios(request, response);
                return;
            }

            int idUsuario = Integer.parseInt(idUsuarioStr);
            
            // Validar que no se elimine a sí mismo
            Integer idUsuarioLogueado = (Integer) session.getAttribute("idUsuario");
            if (idUsuario == idUsuarioLogueado) {
                request.setAttribute("mensaje", "❌ No puede eliminar su propia cuenta");
                listarUsuarios(request, response);
                return;
            }

            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            boolean exito = dao.eliminarUsuario(idUsuario);

            if (exito) {
                request.setAttribute("mensaje", "✅ Usuario eliminado exitosamente");
                request.setAttribute("tipoMensaje", "success");
            } else {
                request.setAttribute("mensaje", "❌ Error al eliminar el usuario");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de usuario inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al eliminar usuario");
            return;
        }

        listarUsuarios(request, response);
    }

    /**
     * Validar formato de email
     */
    private boolean esEmailValido(String email) {
        String emailPattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        return Pattern.matches(emailPattern, email);
    }

    /**
     * Validar fortaleza de contraseña
     */
    private boolean esPasswordSeguro(String password) {
        return password.length() >= 8 &&
               password.matches(".*[A-Z].*") &&  // Al menos una mayúscula
               password.matches(".*[a-z].*") &&  // Al menos una minúscula
               password.matches(".*\\d.*");      // Al menos un número
    }

    /**
     * Encriptar contraseña usando SHA-256
     */
    private String encriptarPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashedPassword = md.digest(password.getBytes("UTF-8"));
        
        StringBuilder sb = new StringBuilder();
        for (byte b : hashedPassword) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    /**
     * Manejo centralizado de errores
     */
    private void manejarError(HttpServletRequest request, HttpServletResponse response, 
                             Exception e, String mensajeContexto) 
            throws ServletException, IOException {
        
        System.err.println("=== ERROR EN USUARIO SISTEMA CONTROLADOR ===");
        System.err.println("Contexto: " + mensajeContexto);
        System.err.println("Mensaje: " + e.getMessage());
        e.printStackTrace();

        request.setAttribute("mensaje", "❌ " + mensajeContexto + ": " + e.getMessage());
        request.setAttribute("tipoMensaje", "error");
        
        request.getRequestDispatcher("Login.jsp").forward(request, response);
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
        return "Controlador para gestión completa de usuarios del sistema";
    }
}