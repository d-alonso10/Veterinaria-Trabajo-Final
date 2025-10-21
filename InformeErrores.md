
-----

## Informe Detallado de Análisis y Errores del Proyecto

### Resumen Ejecutivo

Este informe detalla los hallazgos tras una revisión completa del código fuente.

**Lo que Funciona Correctamente (La Base Sólida):**

  * **1. Capa de Datos (DAO vs. SP):** Esta conexión es **excelente**. He verificado los nuevos DAOs que mencionaste (`PaqueteServicioDao`, `ReporteDao`, `UsuarioSistemaDao`, `PagoDao`, `DashboardDao`, `UtilidadesDao`, `PromocionDao`, etc.) contra los archivos SQL (`Base de datos Veterinaria.sql`, `Nuevos Procedimientos Almacenados.md`, `Procedimientos Almacenados No Funcionales.md`). Las llamadas (`CALL sp_...`), el número de parámetros (`?`) y los tipos de datos son coherentes.
  * **2. Capa de Lógica (Servlet vs. DAO):** Esta conexión es **buena**. Los Servlets (como `ReporteControlador` o `ClienteControlador`) instancian correctamente sus DAOs correspondientes, ejecutan los métodos y reciben los datos (DTOs o Listas).

**Los Fallos Críticos (La Causa de los Problemas):**

  * **1. Fallo Grave de Referencias (Ruptura de MVC):** La Vista (JSP) está invadiendo las responsabilidades del Modelo (DAO) y del Controlador (Servlet). Los JSPs se enlazan *entre sí* (`href="ListaClientes.jsp"`) en lugar de al Controlador, y para funcionar, se ven forzados a **instanciar y ejecutar DAOs directamente**, lo cual es un anti-patrón severo.
  * **2. Fallo Crítico de Redirección (Anti-Patrón Post-Forward):** Las acciones que modifican datos (POST) como crear un cliente o una promoción, utilizan `forward` para recargar el formulario. Esto es peligroso, ya que una simple recarga de página (F5) por parte del usuario **provocará que el dato se inserte múltiples veces en la base de datos**.

-----

### Fallo 1 (Crítico): Ruptura del Patrón MVC (Errores de Referencias)

Este es el problema de "referencias" que mencionaste, y es el más fundamental. Tu aplicación no sigue un flujo MVC consistente.

**Descripción del Problema:**
El patrón Modelo-Vista-Controlador (MVC) dicta que toda petición del usuario debe ir a un **Controlador** (Servlet). El Servlet llama al **Modelo** (DAO) para obtener datos, y luego "despacha" esos datos a una **Vista** (JSP) para que esta *únicamente* los muestre.

En tu proyecto, los hipervínculos (especialmente en el menú) apuntan directamente a los archivos JSPs, saltándose por completo al Servlet.

**Evidencia Concreta:**
La fuente principal de este error es tu menú:

  * `web/includes/menu.jsp` contiene enlaces directos a las vistas, por ejemplo:
      * `<li><a href="ListaClientes.jsp">...</a></li>`
      * `<li><a href="ListaMascotas.jsp">...</a></li>`
      * `<li><a href="ListaGroomers.jsp">...</a></li>`
      * `<li><a href="ListaServicios.jsp">...</a></li>`
      * Y muchos más...

**La Consecuencia Directa (DAO en el JSP):**
Como el usuario va directo al JSP, el Servlet nunca se ejecuta. Por lo tanto, `request.getAttribute("listaDeClientes")` es `null`. Para "solucionar" esto, se añadió código Java (scriptlets) *dentro* del JSP para que él mismo consulte a la base de datos.

  * **Evidencia en `web/ListaMascotas.jsp`**:
    ```jsp
    <%@page import="dao.MascotaDao"%>
    <%@page import="modelo.MascotaBusquedaDTO"%>
    <%
        MascotaDao dao = new MascotaDao();
        List<MascotaBusquedaDTO> mascotas = dao.buscarMascotas("");
        // ... (lógica de presentación)
    %>
    ```
  * **Evidencia en `web/ListaGroomers.jsp`**:
    ```jsp
    <%@page import="dao.GroomerDao"%>
    <%@page import="modelo.Groomer"%>
    <%
        GroomerDao dao = new GroomerDao();
        List<Groomer> groomers = dao.listarGroomers();
    %>
    ```
  * **Evidencia en `web/ListaClientes.jsp`**:
    ```jsp
    <% 
        List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
        // ...
        if (clientes == null) {
            // Este es el "fallback" que se está ejecutando siempre
            ClienteDao dao = new ClienteDao(); 
            clientes = dao.buscarClientes("");
        }
    %>
    ```

**Por qué es un Fallo:**
Esto crea "código spaghetti". Tienes lógica de acceso a datos (`new MascotaDao()`) mezclada con lógica de presentación (`<table>`). Si quieres cambiar la consulta (por ejemplo, añadir un filtro de sucursal), tienes que editar el JSP, lo cual es incorrecto.

**Cómo Identificaste Módulos "Buenos" y "Malos":**
Tus módulos nuevos como `ReporteDao` y `DashboardDao` **SÍ están bien implementados**. ¿Por qué? Porque `ReporteControlador` y `DashboardControlador` SÍ siguen el patrón MVC. Estos servlets obtienen los datos del DAO y usan `forward` al JSP (`ReporteIngresos.jsp`, `Dashboard.jsp`). Estos JSPs "tontos" solo pintan los datos que reciben, lo cual es perfecto.

**Solución (Acciones Críticas):**

1.  **Eliminar DAOs de JSPs:** Debes **borrar** todas las importaciones `dao.*` y cualquier línea que contenga `new ...Dao()` de TODOS tus archivos JSP (`ListaClientes.jsp`, `ListaMascotas.jsp`, `ListaGroomers.jsp`, etc.).
2.  **Corregir `menu.jsp`:** Debes cambiar **todos** los enlaces en `web/includes/menu.jsp` para que apunten a sus respectivos Controladores.
      * **INCORRECTO:** `<a href="ListaClientes.jsp">...</a>`
      * **CORRECTO:** `<a href="ClienteControlador?accion=listarTodos">...</a>`
      * **INCORRECTO:** `<a href="ListaMascotas.jsp">...</a>`
      * **CORRECTO:** `<a href="MascotaControlador?accion=listarTodas">...</a>`
      * **INCORRECTO:** `<a href="Dashboard.jsp">...</a>`
      * **CORRECTO:** `<a href="DashboardControlador">...</a>`
3.  **Corregir otros enlaces:** Revisa todos los JSPs y cambia cualquier `href="Otro.jsp"` por `href="OtroControlador?accion=..."`.

-----

### Fallo 2 (Crítico): Uso Incorrecto de `forward` (Errores de Redirecciones)

Este es el problema de "redirecciones" y es un riesgo de seguridad de datos.

**Descripción del Problema:**
Tu sistema utiliza `RequestDispatcher.forward()` después de una operación que modifica la base de datos (un `INSERT`, `UPDATE` o `DELETE` ejecutado mediante un POST).

**Evidencia Concreta:**
Esto ocurre en casi todos los Servlets que crean entidades, incluyendo los nuevos módulos que solicitaste revisar.

  * **`ClienteControlador.java`**:
    ```java
    // Dentro del método insertarCliente (que maneja "acc=Confirmar")
    request.getRequestDispatcher("InsertarCliente.jsp").forward(request, response);
    ```
  * **`PromocionControlador.java`**:
    ```java
    // Dentro del case "crear"
    request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
    ```
  * **`UsuarioSistemaControlador.java`**:
    ```java
    // Dentro del case "crear"
    request.getRequestDispatcher("CrearUsuario.jsp").forward(request, response);
    ```
  * **`PaqueteServicioControlador.java`**:
    ```java
    // Dentro del case "crear"
    request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
    ```
  * **`UtilidadesControlador.java`**:
    ```java
    // Dentro de recalcularFacturas (una acción POST)
    request.getRequestDispatcher("UtilidadesFacturas.jsp").forward(request, response);
    ```

**La Consecuencia Directa (Duplicación de Datos):**

1.  Un usuario completa el formulario `InsertarCliente.jsp` y presiona "Guardar".
2.  La petición POST viaja a `ClienteControlador`.
3.  El Servlet guarda el cliente en la BD.
4.  El Servlet hace `forward` a `InsertarCliente.jsp`, mostrando "¡Éxito\!".
5.  La URL en el navegador del usuario sigue siendo `.../ClienteControlador`.
6.  El usuario, por costumbre o error, presiona **F5 (Refrescar)**.
7.  El navegador advierte "¿Reenviar formulario?" y el usuario acepta.
8.  La petición POST se envía *de nuevo*.
9.  El `ClienteControlador` recibe los mismos datos y **crea un cliente duplicado en la BD**.

Esto mismo sucede para Promociones, Usuarios, Paquetes, y se re-ejecutan las Utilidades.

**Solución (Acciones Críticas):**
Debes implementar el patrón **Post-Redirect-Get (PRG)**. Cualquier acción POST que modifique datos *debe* terminar con un `response.sendRedirect()`.

  * **Ejemplo de Corrección en `PromocionControlador.java`:**
    ```java
    // Dentro del case "crear"
    try {
        // ... (código para obtener parámetros y crear el objeto 'promo')
        PromocionDao dao = new PromocionDao();
        boolean exito = dao.crearPromocion(promo);

        if (exito) {
            // ¡CORRECTO! Redirigir a una página GET (la acción de listar)
            // Añadimos un parámetro para que la lista sepa mostrar el mensaje
            response.sendRedirect("PromocionControlador?accion=listar&creado=exito");
        } else {
            // Si el DAO falla, SÍ hacemos forward para mostrar el error en el formulario
            request.setAttribute("mensaje", "❌ Error: No se pudo crear la promoción.");
            request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
        }
    } catch (Exception e) {
        request.setAttribute("mensaje", "❌ Error del sistema: " + e.getMessage());
        request.getRequestDispatcher("CrearPromocion.jsp").forward(request, response);
    }
    ```
  * **En el JSP (`ListaPromociones.jsp`)**, tendrías que añadir un scriptlet para leer este parámetro:
    ```jsp
    <%
        if ("exito".equals(request.getParameter("creado"))) {
            out.println("<div class='mensaje exito'>✅ Promoción creada exitosamente.</div>");
        }
    %>
    ```

-----

### Fallo 3 (Menor): Rutas Relativas Frágiles

**Descripción del Problema:**
Todas las referencias a Servlets y JSPs en tu código (en `href` y `action`) son relativas, por ejemplo: `action="ClienteControlador"`.

**Consecuencia:**
Esto funciona bien en `localhost:8080/`. Sin embargo, si alguna vez despliegas la aplicación en un "contexto" diferente (ej. `www.miveterinaria.com/sistema/`), todos los enlaces se romperán, porque `action="ClienteControlador"` intentará ir a `www.miveterinaria.com/ClienteControlador` en lugar de `www.miveterinaria.com/sistema/ClienteControlador`.

**Solución (Recomendada):**
Ya que estás usando scriptlets (y no JSTL/EL), debes usar el método `request.getContextPath()` para construir todas tus URLs.

  * **INCORRECTO:**
    ```jsp
    <form action="ClienteControlador" method="POST">
    <a href="ClienteControlador?accion=listarTodos">Ver Clientes</a>
    ```
  * **CORRECTO (con Scriptlets):**
    ```jsp
    <form action="<%= request.getContextPath() %>/ClienteControlador" method="POST">
    <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarTodos">Ver Clientes</a>
    ```

Debes aplicar este prefijo `<%= request.getContextPath() %>` a **cada** `href` y `action` que apunte a un recurso de tu aplicación.

-----

### Plan de Acción Recomendado (Resumen)

Para corregir tu aplicación, te recomiendo seguir estos pasos en orden de prioridad:

1.  **Prioridad 1: Corregir Referencias (Fallo MVC):**

      * **Acción A:** Ir a `web/includes/menu.jsp` y cambiar todos los `href="Archivo.jsp"` por `href="Controlador?accion=..."`.
      * **Acción B:** Ir a `ListaClientes.jsp`, `ListaMascotas.jsp`, `ListaGroomers.jsp`, etc., y **eliminar** todo el código Java que llame a `new ...Dao()`. Estos JSPs ahora dependerán 100% de que el Servlet les envíe los datos.

2.  **Prioridad 2: Corregir Redirecciones (Fallo PRG):**

      * **Acción:** Ir a **todos** los Servlets (`ClienteControlador`, `PromocionControlador`, `UsuarioSistemaControlador`, `PaqueteServicioControlador`, `UtilidadesControlador`, etc.). En todos los métodos `doPost` (o `case` de "crear", "actualizar", "eliminar"), cambiar la línea final `request.getRequestDispatcher(...).forward(...)` por `response.sendRedirect("...Controlador?accion=listar&status=exito")`.

3.  **Prioridad 3: Robustecer las Rutas:**

      * **Acción:** Hacer una búsqueda global en todos los JSPs de `action="` y `href="` que apunten a tus servlets, y añadirles el prefijo `<%= request.getContextPath() %>/`.