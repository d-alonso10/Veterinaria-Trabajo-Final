package control;

import dao.UsuarioSistemaDao;
import modelo.UsuarioSistema;
import java.io.IOException;
import java.security.MessageDigest;
import java.util.ArrayList; // Import añadido
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
                        // Acción eliminada ya que el campo 'estado' no existe
                        System.err.println("WARN: La acción 'cambiarEstado' fue invocada pero está deshabilitada (campo 'estado' no existe).");
                        response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=listar&warn=estado_no_impl");
                        break;
                    case "buscarUsuarios":
                        buscarUsuarios(request, response);
                        break;
                    case "eliminarUsuario":
                        eliminarUsuario(request, response);
                        break;
                    case "obtenerPerfil": // Renombrado para claridad
                    case "mostrarPerfil": // Acción GET para mostrar el perfil
                         obtenerPerfilUsuario(request, response);
                         break;
                    case "listar":
                        listarUsuarios(request, response);
                        break;
                    case "mostrarFormulario":
                        mostrarFormularioCreacion(request, response);
                        break;
                    default:
                        // Si hay sesión, ir al menú, si no, al login
                        HttpSession session = request.getSession(false);
                        if (session != null && session.getAttribute("usuarioLogueado") != null) {
                            response.sendRedirect(request.getContextPath() + "/Menu.jsp");
                        } else {
                            response.sendRedirect("Login.jsp");
                        }
                }
            } else {
                 // Si hay sesión, ir al menú, si no, al login
                HttpSession session = request.getSession(false);
                if (session != null && session.getAttribute("usuarioLogueado") != null) {
                     response.sendRedirect(request.getContextPath() + "/Menu.jsp");
                } else {
                    response.sendRedirect("Login.jsp");
                }
            }
        } catch (Exception e) {
            manejarErrorGeneral(request, response, e, "Error general en el controlador de usuarios");
        }
    }

    /**
     * Maneja el inicio de sesión de usuarios
     */
    private void iniciarSesion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = limpiarParametro(request.getParameter("email"));
            String password = limpiarParametro(request.getParameter("password"));
            String recordarSesion = request.getParameter("recordarSesion");

            if (email.isEmpty() || password.isEmpty()) {
                manejarErrorVista(request, response, "Login.jsp", "❌ Email y contraseña son obligatorios");
                return;
            }
            if (!esEmailValido(email)) {
                 manejarErrorVista(request, response, "Login.jsp", "❌ Formato de email inválido");
                return;
            }

            String passwordHash = encriptarPassword(password);
            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            UsuarioSistema usuario = dao.validarUsuario(email, passwordHash);

            if (usuario != null) {
                // Ya no se verifica el estado 'ACTIVO' porque el campo no existe

                HttpSession session = request.getSession(true);
                session.setAttribute("usuarioLogueado", usuario);
                session.setAttribute("idUsuario", usuario.getIdUsuario());
                session.setAttribute("nombreUsuario", usuario.getNombre());
                session.setAttribute("rolUsuario", usuario.getRol());
                session.setAttribute("emailUsuario", usuario.getEmail());

                if ("on".equals(recordarSesion)) {
                    session.setMaxInactiveInterval(30 * 24 * 60 * 60); // 30 días
                } else {
                    session.setMaxInactiveInterval(8 * 60 * 60); // 8 horas
                }

                dao.registrarUltimoAcceso(usuario.getIdUsuario());

                 // Redirección centralizada
                redirigirSegunRol(response, usuario.getRol(), request); // Pasar request para context path

            } else {
                dao.registrarIntentoFallidoLogin(email);
                request.setAttribute("emailIntentado", email);
                manejarErrorVista(request, response, "Login.jsp", "❌ Credenciales incorrectas");
            }

        } catch (Exception e) {
            manejarErrorGeneral(request, response, e, "Error al iniciar sesión");
        }
    }

     /**
     * Redirige a la página principal según el rol del usuario, usando ContextPath.
     */
    private void redirigirSegunRol(HttpServletResponse response, String rol, HttpServletRequest request) throws IOException {
         String targetPage = "/Menu.jsp"; // Página por defecto (relativa al context path)
         if (rol != null) {
              switch (rol.toUpperCase()) { // Usa UpperCase para comparar roles
                  case "ADMINISTRADOR":
                      targetPage = "/Menu.jsp"; // O Dashboard.jsp si prefieres
                      break;
                  case "VETERINARIO":
                      targetPage = "/ColaAtencion.jsp"; // Ajusta si la URL es diferente
                      break;
                  case "RECEPCIONISTA":
                      targetPage = "/ProximasCitas.jsp"; // Ajusta si la URL es diferente
                      break;
                  // Añade otros roles si es necesario
                   case "GROOMER":
                       // Define a dónde debe ir un Groomer
                       targetPage = "/Menu.jsp"; // Ejemplo: al menú general
                       break;
                   case "CONTADOR":
                        // Define a dónde debe ir un Contador
                       targetPage = "/ReporteControlador?accion=listar"; // Ejemplo: a reportes
                       break;
              }
         }
        response.sendRedirect(request.getContextPath() + targetPage);
    }


    /**
     * Cierra la sesión del usuario actual
     */
    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                UsuarioSistema usuario = (UsuarioSistema) session.getAttribute("usuarioLogueado");
                if (usuario != null) {
                    UsuarioSistemaDao dao = new UsuarioSistemaDao();
                    dao.registrarCierreSesion(usuario.getIdUsuario());
                }
                session.invalidate();
            }
            // Añadir context path a la redirección
            response.sendRedirect(request.getContextPath() + "/Login.jsp?mensaje=logout_exitoso");

        } catch (Exception e) {
            System.err.println("Error al cerrar sesión: " + e.getMessage());
             // Añadir context path a la redirección
            response.sendRedirect(request.getContextPath() + "/Login.jsp?mensaje=error_logout");
        }
    }

    /**
     * Registra un nuevo usuario en el sistema
     */
    private void registrarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vistaError = "CrearUsuario.jsp"; // Vista a la que volver en caso de error
        try {
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String email = limpiarParametro(request.getParameter("email"));
            String password = limpiarParametro(request.getParameter("password"));
            String confirmPassword = limpiarParametro(request.getParameter("confirmPassword"));
            String rol = limpiarParametro(request.getParameter("rol"));

            // Validaciones (Usando manejarErrorVista para devolver al formulario)
            if (nombre.isEmpty() || email.isEmpty() || password.isEmpty() || rol.isEmpty()) {
                manejarErrorVista(request, response, vistaError, "❌ Todos los campos son obligatorios"); return; }
            if (!password.equals(confirmPassword)) {
                manejarErrorVista(request, response, vistaError, "❌ Las contraseñas no coinciden"); return; }
            if (nombre.length() < 2 || nombre.length() > 100) {
                 manejarErrorVista(request, response, vistaError, "❌ El nombre debe tener entre 2 y 100 caracteres"); return; }
            if (!esEmailValido(email)) {
                 manejarErrorVista(request, response, vistaError, "❌ Formato de email inválido"); return; }
            if (!esPasswordSeguro(password)) {
                 manejarErrorVista(request, response, vistaError, "❌ La contraseña no cumple los requisitos (mín 8 chars, mayús, minús, núm)"); return; }

            // Validar rol (mejorado)
             String rolValidado = validarRol(rol);
             if (rolValidado == null) {
                  manejarErrorVista(request, response, vistaError, "❌ Rol no válido"); return;
             }
             rol = rolValidado; // Usar el rol validado en mayúsculas


            HttpSession session = request.getSession(false);
            // Verifica permiso y maneja el caso donde session es null o el rol no es el esperado
            if (session == null || !"ADMINISTRADOR".equalsIgnoreCase( (String) session.getAttribute("rolUsuario"))) {
                manejarErrorVista(request, response, vistaError, "❌ No tiene permisos para registrar usuarios"); return;
            }


            UsuarioSistemaDao dao = new UsuarioSistemaDao();
             // Verificar si el email ya existe ANTES de intentar insertar
             if (dao.existeEmail(email)) {
                 manejarErrorVista(request, response, vistaError, "❌ El email ya está registrado"); return;
             }


            String passwordHash = encriptarPassword(password);
            UsuarioSistema usuario = new UsuarioSistema();
            usuario.setNombre(nombre);
            usuario.setEmail(email);
            usuario.setPasswordHash(passwordHash);
            usuario.setRol(rol);
             // NO se establece estado inicial porque el campo no existe


            int idUsuarioCreado = dao.registrarUsuarioSistema(usuario);

            if (idUsuarioCreado > 0) {
                // PRG: Redirigir a la lista con mensaje de éxito
                response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=listar&creado=exito&id=" + idUsuarioCreado);
                // No necesita return aquí porque sendRedirect termina la respuesta
            } else {
                 manejarErrorVista(request, response, vistaError, "❌ Error al registrar usuario. Intente nuevamente.");
            }

        } catch (Exception e) {
             // Error general, redirigir a una página de error o al formulario con mensaje
             manejarErrorVista(request, response, vistaError, "❌ Error del sistema al registrar: " + e.getMessage());
        }
         // No debe haber un forward aquí si se usa PRG
    }


    /**
     * Valida y normaliza el rol del usuario.
     */
     private String validarRol(String rolInput) {
         if (rolInput == null || rolInput.trim().isEmpty()) {
             return null;
         }
         String rolUpper = rolInput.trim().toUpperCase();
         // Lista de roles válidos según la definición ENUM en la BD
         String[] rolesPermitidos = {"RECEPCIONISTA", "ADMIN", "GROOMER", "CONTADOR", "VETERINARIO"};
         for (String rolPermitido : rolesPermitidos) {
             if (rolPermitido.equals(rolUpper)) {
                 // Mapea 'ADMIN' a 'ADMINISTRADOR' si tu código Java usa ese término internamente
                 //if ("ADMIN".equals(rolUpper)) return "ADMINISTRADOR";
                 return rolPermitido; // Devuelve el rol tal como está en la BD
             }
         }
          // Si tu código usa "ADMINISTRADOR" pero la BD tiene "ADMIN", necesitas el mapeo:
         if ("ADMINISTRADOR".equals(rolUpper)) return "ADMIN";

         return null; // Rol no válido
     }


    /**
     * Lista todos los usuarios del sistema
     */
    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("rolUsuario"))) { // Compara con ADMIN (de BD)
                response.sendRedirect(request.getContextPath() + "/Menu.jsp?mensaje=permiso_denegado");
                return;
            }

             // Manejo de mensajes de éxito de acciones previas (PRG)
            String creado = request.getParameter("creado");
            String actualizado = request.getParameter("actualizado");
            String eliminado = request.getParameter("eliminado");
            // String estadoCambiado = request.getParameter("estadoCambiado"); // No aplica sin campo estado
            String idParam = request.getParameter("id");

            if ("exito".equals(creado)) {
                request.setAttribute("mensaje", "✅ Usuario" + (idParam != null ? " ID " + idParam : "") + " creado exitosamente.");
                request.setAttribute("tipoMensaje", "exito");
            } else if ("exito".equals(actualizado)) {
                request.setAttribute("mensaje", "✅ Usuario" + (idParam != null ? " ID " + idParam : "") + " actualizado exitosamente.");
                request.setAttribute("tipoMensaje", "exito");
            } else if ("exito".equals(eliminado)) {
                 request.setAttribute("mensaje", "✅ Usuario" + (idParam != null ? " ID " + idParam : "") + " eliminado exitosamente.");
                 request.setAttribute("tipoMensaje", "exito");
            } /* else if ("exito".equals(estadoCambiado)) { // No aplica sin campo estado
                 String accionEstado = request.getParameter("usuarioAccion");
                 request.setAttribute("mensaje", "✅ Usuario" + (idParam != null ? " ID " + idParam : "") + " " + (accionEstado != null ? accionEstado : "con estado cambiado") + " exitosamente.");
                 request.setAttribute("tipoMensaje", "exito");
            } */
             // Añadir manejo de advertencias (como estado no implementado)
             String warn = request.getParameter("warn");
             if ("estado_no_impl".equals(warn)) {
                 request.setAttribute("mensaje", "⚠️ La función de cambiar estado de usuario está deshabilitada.");
                 request.setAttribute("tipoMensaje", "info"); // O 'warning' si tienes ese estilo CSS
             }


            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            List<UsuarioSistema> usuarios = dao.listarTodosUsuarios();

            request.setAttribute("usuarios", usuarios);
            request.setAttribute("totalUsuarios", usuarios != null ? usuarios.size() : 0);

            if (usuarios != null && !usuarios.isEmpty()) {
                // Calcular estadísticas si hay usuarios
                int administradores = 0, veterinarios = 0, recepcionistas = 0, groomers = 0, contadores=0, otros = 0;
                // int activos = 0, inactivos = 0; // No aplica sin campo estado

                for (UsuarioSistema usuario : usuarios) {
                    if (usuario.getRol() != null) {
                         // Comparar con roles de la BD
                        switch (usuario.getRol().toUpperCase()) {
                            case "ADMIN": administradores++; break;
                            case "VETERINARIO": veterinarios++; break;
                            case "RECEPCIONISTA": recepcionistas++; break;
                            case "GROOMER": groomers++; break;
                            case "CONTADOR": contadores++; break;
                            default: otros++;
                        }
                    } else {
                        otros++;
                    }

                    // No se cuentan activos/inactivos
                }
                request.setAttribute("administradores", administradores);
                request.setAttribute("veterinarios", veterinarios);
                request.setAttribute("recepcionistas", recepcionistas);
                request.setAttribute("groomers", groomers);
                request.setAttribute("contadores", contadores);
                request.setAttribute("otrosRoles", otros);
                // request.setAttribute("usuariosActivos", activos); // No aplica
                // request.setAttribute("usuariosInactivos", inactivos); // No aplica

                 if (request.getAttribute("mensaje") == null) {
                      request.setAttribute("mensaje", "✅ Lista de usuarios cargada (" + usuarios.size() + ")");
                 }

            } else {
                 if (request.getAttribute("mensaje") == null) {
                      request.setAttribute("mensaje", "ℹ️ No existen usuarios registrados");
                 }
            }

        } catch (Exception e) {
             System.err.println("Error grave al listar usuarios: " + e.getMessage());
             e.printStackTrace();
             request.setAttribute("mensaje", "❌ Error crítico al cargar la lista de usuarios.");
             request.setAttribute("tipoMensaje", "error");
             request.setAttribute("usuarios", new ArrayList<UsuarioSistema>());
             request.setAttribute("totalUsuarios", 0);
        }

        request.getRequestDispatcher("ListaUsuarios.jsp").forward(request, response);
    }

    /**
     * Cambia la contraseña del usuario logueado
     */
    private void cambiarPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vistaError = "CambiarPassword.jsp";
        try {
            String passwordActual = limpiarParametro(request.getParameter("passwordActual"));
            String passwordNuevo = limpiarParametro(request.getParameter("passwordNuevo"));
            String confirmPasswordNuevo = limpiarParametro(request.getParameter("confirmPasswordNuevo"));

            if (passwordActual.isEmpty() || passwordNuevo.isEmpty() || confirmPasswordNuevo.isEmpty()) {
                manejarErrorVista(request, response, vistaError, "❌ Todos los campos son obligatorios"); return; }
            if (!passwordNuevo.equals(confirmPasswordNuevo)) {
                manejarErrorVista(request, response, vistaError, "❌ Las contraseñas nuevas no coinciden"); return; }
            if (!esPasswordSeguro(passwordNuevo)) {
                manejarErrorVista(request, response, vistaError, "❌ La contraseña nueva no cumple los requisitos"); return; }

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("usuarioLogueado") == null) {
                response.sendRedirect(request.getContextPath() + "/Login.jsp?mensaje=sesion_expirada"); return; }

            UsuarioSistema usuarioLogueado = (UsuarioSistema) session.getAttribute("usuarioLogueado");
            String passwordActualHash = encriptarPassword(passwordActual);
            UsuarioSistemaDao dao = new UsuarioSistemaDao();

            if (!dao.verificarPasswordActual(usuarioLogueado.getIdUsuario(), passwordActualHash)) {
                manejarErrorVista(request, response, vistaError, "❌ Contraseña actual incorrecta"); return; }

            String passwordNuevoHash = encriptarPassword(passwordNuevo);
            boolean exito = dao.cambiarPassword(usuarioLogueado.getIdUsuario(), passwordNuevoHash);

            if (exito) {
                // PRG: Redirigir al perfil con mensaje de éxito
                response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=mostrarPerfil&passwordCambiada=exito");
            } else {
                 manejarErrorVista(request, response, vistaError, "❌ Error al actualizar la contraseña en la base de datos");
            }

        } catch (Exception e) {
             manejarErrorVista(request, response, vistaError, "❌ Error del sistema al cambiar contraseña: " + e.getMessage());
        }
    }

    /**
     * Actualiza el perfil del usuario actual (nombre, email)
     */
    private void actualizarPerfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vistaError = "PerfilUsuario.jsp";
        try {
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String email = limpiarParametro(request.getParameter("email"));

            if (nombre.isEmpty() || email.isEmpty()) {
                manejarErrorVista(request, response, vistaError, "❌ Nombre y email son obligatorios"); return; }
             if (nombre.length() < 2 || nombre.length() > 100) {
                 manejarErrorVista(request, response, vistaError, "❌ El nombre debe tener entre 2 y 100 caracteres"); return; }
            if (!esEmailValido(email)) {
                manejarErrorVista(request, response, vistaError, "❌ Formato de email inválido"); return; }

            HttpSession session = request.getSession(false);
             if (session == null || session.getAttribute("usuarioLogueado") == null) {
                 response.sendRedirect(request.getContextPath() + "/Login.jsp?mensaje=sesion_expirada"); return; }

            UsuarioSistema usuarioLogueado = (UsuarioSistema) session.getAttribute("usuarioLogueado");
            UsuarioSistemaDao dao = new UsuarioSistemaDao();

             if (!email.equalsIgnoreCase(usuarioLogueado.getEmail()) && dao.existeEmail(email)) {
                 manejarErrorVista(request, response, vistaError, "❌ El nuevo email ya está registrado por otro usuario"); return;
             }


            boolean exito = dao.actualizarPerfil(usuarioLogueado.getIdUsuario(), nombre, email);

            if (exito) {
                // Actualizar sesión
                usuarioLogueado.setNombre(nombre);
                usuarioLogueado.setEmail(email);
                session.setAttribute("usuarioLogueado", usuarioLogueado);
                session.setAttribute("nombreUsuario", nombre);
                session.setAttribute("emailUsuario", email);

                // PRG: Redirigir al perfil con mensaje de éxito
                response.sendRedirect(request.getContextPath() + "/UsuarioSistemaControlador?accion=mostrarPerfil&actualizado=exito");
            } else {
                 manejarErrorVista(request, response, vistaError, "❌ Error al actualizar el perfil en la base de datos");
            }

        } catch (Exception e) {
             manejarErrorVista(request, response, vistaError, "❌ Error del sistema al actualizar perfil: " + e.getMessage());
        }
    }

    /**
     * Busca usuarios por criterios (GET request, muestra formulario y resultados)
     * Versión SIN campo estado.
     */
    private void buscarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vista = "BuscarUsuarios.jsp";
        try {
            HttpSession session = request.getSession(false);
             if (session == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("rolUsuario"))) { // Compara con ADMIN
                 response.sendRedirect(request.getContextPath() + "/Menu.jsp?mensaje=permiso_denegado"); return;
            }

            String termino = limpiarParametro(request.getParameter("termino"));
            String rol = limpiarParametro(request.getParameter("rol"));
            // String estado = null; // No se usa estado

             List<UsuarioSistema> usuarios = null;
             boolean busquedaRealizada = request.getParameter("buscarBtn") != null;

            if (busquedaRealizada) {
                UsuarioSistemaDao dao = new UsuarioSistemaDao();
                 usuarios = dao.buscarUsuarios(termino, rol); // Llama al método sin estado

                 if (usuarios != null && !usuarios.isEmpty()) {
                    request.setAttribute("mensaje", "✅ Se encontraron " + usuarios.size() + " usuarios");
                    request.setAttribute("tipoMensaje", "info");
                } else {
                    request.setAttribute("mensaje", "ℹ️ No se encontraron usuarios con los criterios especificados");
                    request.setAttribute("tipoMensaje", "info");
                }
            } else {
                 usuarios = new ArrayList<>();
            }

            request.setAttribute("usuarios", usuarios);
            request.setAttribute("totalResultados", usuarios != null ? usuarios.size() : 0);
            request.setAttribute("terminoBusqueda", termino);
            request.setAttribute("rolBusqueda", rol);
            // No se pasa estadoBusqueda

        } catch (Exception e) {
             System.err.println("Error al buscar usuarios: " + e.getMessage());
             e.printStackTrace();
             request.setAttribute("mensaje", "❌ Error del sistema al realizar la búsqueda.");
             request.setAttribute("tipoMensaje", "error");
             request.setAttribute("usuarios", new ArrayList<UsuarioSistema>());
        }

        request.getRequestDispatcher(vista).forward(request, response);
    }

    /**
     * Obtiene y muestra el perfil del usuario logueado (GET request)
     */
    private void obtenerPerfilUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         String vista = "PerfilUsuario.jsp";
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("usuarioLogueado") == null) {
                response.sendRedirect(request.getContextPath() + "/Login.jsp?mensaje=sesion_expirada"); return;
            }

             String actualizado = request.getParameter("actualizado");
             String passwordCambiada = request.getParameter("passwordCambiada");
             if ("exito".equals(actualizado)) {
                  request.setAttribute("mensaje", "✅ Perfil actualizado correctamente.");
                  request.setAttribute("tipoMensaje", "exito");
             } else if ("exito".equals(passwordCambiada)) {
                  request.setAttribute("mensaje", "✅ Contraseña cambiada correctamente.");
                  request.setAttribute("tipoMensaje", "exito");
             }

             UsuarioSistema usuarioLogueadoSesion = (UsuarioSistema) session.getAttribute("usuarioLogueado");
            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            UsuarioSistema perfilCompleto = dao.obtenerPerfilCompleto(usuarioLogueadoSesion.getIdUsuario());

            if (perfilCompleto != null) {
                request.setAttribute("perfilUsuario", perfilCompleto);
                 session.setAttribute("usuarioLogueado", perfilCompleto);
                 session.setAttribute("nombreUsuario", perfilCompleto.getNombre());
                 session.setAttribute("emailUsuario", perfilCompleto.getEmail());
            } else {
                 System.err.println("Error crítico: No se encontró el perfil del usuario ID " + usuarioLogueadoSesion.getIdUsuario());
                 session.invalidate();
                 response.sendRedirect(request.getContextPath() + "/Login.jsp?mensaje=error_perfil"); return;
            }

        } catch (Exception e) {
             System.err.println("Error al obtener perfil: " + e.getMessage());
             e.printStackTrace();
             request.setAttribute("mensaje", "❌ Error del sistema al cargar el perfil.");
             request.setAttribute("tipoMensaje", "error");
        }
         request.getRequestDispatcher(vista).forward(request, response);
    }

    /**
     * Elimina un usuario (acción POST)
     */
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         String vistaRedirect = request.getContextPath() + "/UsuarioSistemaControlador?accion=listar";
        try {
            HttpSession session = request.getSession(false);
             if (session == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("rolUsuario"))) { // Compara con ADMIN
                 response.sendRedirect(request.getContextPath() + "/Menu.jsp?mensaje=permiso_denegado"); return;
            }

            String idUsuarioStr = limpiarParametro(request.getParameter("idUsuario"));

            if (idUsuarioStr.isEmpty()) {
                 response.sendRedirect(vistaRedirect + "&error=id_eliminar_faltante"); return;
            }

            int idUsuario = Integer.parseInt(idUsuarioStr);
            Integer idUsuarioLogueado = (Integer) session.getAttribute("idUsuario");

            if (idUsuarioLogueado != null && idUsuario == idUsuarioLogueado) { // Verifica nulidad
                 response.sendRedirect(vistaRedirect + "&error=auto_eliminar"); return;
            }

            UsuarioSistemaDao dao = new UsuarioSistemaDao();
            boolean exito = dao.eliminarUsuario(idUsuario);

            if (exito) {
                response.sendRedirect(vistaRedirect + "&eliminado=exito&id=" + idUsuario);
            } else {
                 response.sendRedirect(vistaRedirect + "&error=db_fallo_eliminar");
            }

        } catch (NumberFormatException e) {
             response.sendRedirect(vistaRedirect + "&error=id_eliminar_invalido");
        } catch (Exception e) {
             System.err.println("Error al eliminar usuario: " + e.getMessage());
             e.printStackTrace();
             response.sendRedirect(vistaRedirect + "&error=sistema_eliminar");
        }
    }

    /**
     * Muestra el formulario de creación de usuarios (acción GET)
     */
    private void mostrarFormularioCreacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("rolUsuario"))) { // Compara con ADMIN
                 response.sendRedirect(request.getContextPath() + "/Menu.jsp?mensaje=permiso_denegado"); return;
            }
             request.getRequestDispatcher("CrearUsuario.jsp").forward(request, response);
        } catch (Exception e) {
             manejarErrorGeneral(request, response, e, "Error al mostrar formulario de creación");
        }
    }


    /**
     * Valida formato de email
     */
    private boolean esEmailValido(String email) {
        if (email == null) return false;
        String emailPattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        return Pattern.matches(emailPattern, email);
    }

    /**
     * Validar fortaleza de contraseña
     */
    private boolean esPasswordSeguro(String password) {
         if (password == null) return false;
        return password.length() >= 8 &&
               password.matches(".*[A-Z].*") &&
               password.matches(".*[a-z].*") &&
               password.matches(".*\\d.*");
    }

    /**
     * Encriptar contraseña usando SHA-256
     */
    private String encriptarPassword(String password) throws Exception {
         if (password == null) {
             throw new IllegalArgumentException("La contraseña no puede ser nula");
         }
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashedPassword = md.digest(password.getBytes("UTF-8"));

        StringBuilder sb = new StringBuilder(hashedPassword.length * 2);
        for (byte b : hashedPassword) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

     /**
     * Manejo de errores que deben devolver al usuario a una VISTA específica (JSP)
     * conservando datos del formulario si es posible. Usa FORWARD.
     */
    private void manejarErrorVista(HttpServletRequest request, HttpServletResponse response,
                                  String vista, String mensaje)
            throws ServletException, IOException {
        System.err.println("Error en Controlador Usuario: " + mensaje);
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipoMensaje", "error");
         // Conservar datos del formulario (ejemplo para registro)
         if ("CrearUsuario.jsp".equals(vista) || "RegistrarUsuario.jsp".equals(vista)) {
             request.setAttribute("nombrePrevio", request.getParameter("nombre"));
             request.setAttribute("emailPrevio", request.getParameter("email"));
             request.setAttribute("rolPrevio", request.getParameter("rol"));
         }
        request.getRequestDispatcher(vista).forward(request, response);
    }


    /**
     * Manejo centralizado de errores GENERALES del sistema. Usa REDIRECT a una página
     * de error o al login.
     */
    private void manejarErrorGeneral(HttpServletRequest request, HttpServletResponse response,
                             Exception e, String mensajeContexto)
            throws ServletException, IOException {

        System.err.println("=== ERROR GRAVE EN USUARIO SISTEMA CONTROLADOR ===");
        System.err.println("Contexto: " + mensajeContexto);
        System.err.println("Mensaje Excepción: " + e.getMessage());
        e.printStackTrace();

         // Redirigir a login con mensaje de error genérico
        response.sendRedirect(request.getContextPath() + "/Login.jsp?mensaje=error_inesperado");
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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
    }// </editor-fold>

}