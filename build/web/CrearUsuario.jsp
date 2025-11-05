<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
  CORRECCIÓN DE SEGURIDAD:
  Verificar si el usuario en sesión es Administrador ("admin").
  Si no lo es, se redirige a la página de login con un error.
--%>
<%
    // Asumimos que ROL_ADMIN es "admin" (en minúsculas) como en el controlador
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    if (rolUsuario == null || !rolUsuario.equals("admin")) {
        response.sendRedirect("Login.jsp?mensaje=permiso_denegado");
        return; // Detiene la carga del resto de la página
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Usuario - Sistema Veterinario</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
        }
        .container {
            max-width: 600px;
            margin: 20px auto; /* Añadido margen superior/inferior */
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #333;
            margin-top: 0;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        select {
            width: 100%;
            padding: 10px; /* Aumentado padding */
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .btn {
            padding: 12px 20px; /* Aumentado padding */
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
            font-weight: bold;
        }
        .btn:hover {
            background-color: #218838;
        }
        .btn-cancel {
            background-color: #6c757d;
            text-decoration: none; /* Añadido para <a> */
            color: white; /* Añadido para <a> */
        }
        .btn-cancel:hover {
            background-color: #545b62;
        }
        
        /* Estilos para mensajes */
        .message-box {
            text-align: center;
            margin-bottom: 15px;
            padding: 12px;
            border: 1px solid transparent;
            border-radius: 4px;
            font-size: 14px;
        }
        .error {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
        .success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        
        .form-row {
            display: flex;
            flex-wrap: wrap; /* Añadido para responsiveness */
            gap: 15px;
        }
        .form-row .form-group {
            flex: 1;
            min-width: 200px; /* Añadido para responsiveness */
        }
        .password-requirements {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        .actions {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Registrar Nuevo Usuario</h2>
        
        <%-- 
          Lógica de mensajes de error unificada.
          Maneja 'mensaje' y 'tipoMensaje' del controlador.
        --%>
        <%
            String mensajeError = (String) request.getAttribute("mensaje");
            String tipoMensaje = (String) request.getAttribute("tipoMensaje");
            
            if (mensajeError != null) {
                if (tipoMensaje == null || !"error".equals(tipoMensaje)) {
                    tipoMensaje = "error"; // Forzar a "error" si no es un error
                }
        %>
            <div class="message-box <%= tipoMensaje %>">
                <%= mensajeError %>
            </div>
        <%
            }
        %>
        
        <%-- Preparar valores previos del formulario (para repoblar si hay error) --%>
        <%
            String nombrePrevio = request.getAttribute("nombrePrevio") != null ? (String)request.getAttribute("nombrePrevio") : "";
            String emailPrevio = request.getAttribute("emailPrevio") != null ? (String)request.getAttribute("emailPrevio") : "";
            String rolPrevio = request.getAttribute("rolPrevio") != null ? (String)request.getAttribute("rolPrevio") : "";
        %>
        
        <%-- 
          CORRECCIÓN: Se elimina onsubmit="return validarFormulario()"
          Se confía en la validación HTML5 y la validación robusta del servidor (que ya no usa alerts).
        --%>
        <form action="UsuarioSistemaControlador?accion=registrar" method="post">
            
            <div class="form-group">
                <label for="nombre">Nombre Completo:</label>
                <input type="text" id="nombre" name="nombre" 
                       value="<%= nombrePrevio %>" 
                       required maxlength="100" minlength="2">
            </div>
            
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" 
                       value="<%= emailPrevio %>" 
                       required>
            </div>
            
            <div class="form-group">
                <label for="rol">Rol:</label>
                <%-- 
                  CORRECCIÓN: Roles en minúsculas para coincidir con el Controlador y la BD
                --%>
                <select id="rol" name="rol" required>
                    <option value="">Seleccione un rol</option>
                    <option value="veterinario" <%= "veterinario".equals(rolPrevio) ? "selected" : "" %>>Veterinario</option>
                    <option value="recepcionista" <%= "recepcionista".equals(rolPrevio) ? "selected" : "" %>>Recepcionista</option>
                    <option value="admin" <%= "admin".equals(rolPrevio) ? "selected" : "" %>>Administrador</option>
                    <option value="groomer" <%= "groomer".equals(rolPrevio) ? "selected" : "" %>>Groomer</option>
                    <option value="contador" <%= "contador".equals(rolPrevio) ? "selected" : "" %>>Contador</option>
                </select>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="password">Contraseña:</label>
                    <%-- Validación HTML5 con pattern para seguridad de contraseña --%>
                    <input type="password" id="password" name="password" required minlength="8" 
                           pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" 
                           title="Debe tener 8+ caracteres, 1 mayúscula, 1 minúscula y 1 número">
                    <div class="password-requirements">
                        Mínimo 8 caracteres, 1 mayús., 1 minús. y 1 núm.
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirmar Contraseña:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required minlength="8">
                </div>
            </div>
            
            <div class="actions">
                <button type="submit" class="btn">Registrar Usuario</button>
                <a href="UsuarioSistemaControlador?accion=listar" class="btn btn-cancel">Cancelar</a>
            </div>
        </form>
    </div>

    <%-- 
      CORRECCIÓN: Se elimina el bloque <script>
      Las validaciones JS con alert() se han quitado.
      La validación del servidor es más segura y robusta.
    --%>
</body>
</html>