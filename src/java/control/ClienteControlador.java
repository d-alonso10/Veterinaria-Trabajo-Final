package control;

import dao.ClienteDao;
import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Cliente;
import modelo.ClienteFrecuenteDTO;

@WebServlet(urlPatterns = {"/ClienteControlador"})
public class ClienteControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar encoding ANTES de obtener parámetros
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String acc = request.getParameter("acc");
        String accion = request.getParameter("accion"); // Nuevo parámetro para otras operaciones

        // Manejar el insertar existente (tu código actual)
        if (acc != null && acc.equals("Confirmar")) {
            insertarCliente(request, response);
        } // Manejar otras acciones con el nuevo parámetro
        else if (accion != null) {
            switch (accion) {
                case "buscar":
                    buscarClientes(request, response);
                    break;
                case "listarFrecuentes":
                    listarClientesFrecuentes(request, response);
                    break;
                case "listarTodos":
                    listarTodosClientes(request, response);
                    break;
                default:
                    response.sendRedirect("menuClientes.jsp");
            }
        } else {
            response.sendRedirect("InsertarCliente.jsp");
        }
    }

    // MÉTODO ORIGINAL (ya funcionando)
    private void insertarCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener y limpiar parámetros
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String apellido = limpiarParametro(request.getParameter("apellido"));
            String dniRuc = limpiarParametro(request.getParameter("dniRuc"));
            String email = limpiarParametro(request.getParameter("email"));
            String telefono = limpiarParametro(request.getParameter("telefono"));
            String direccion = limpiarParametro(request.getParameter("direccion"));
            String preferencias = limpiarParametro(request.getParameter("preferencias"));

            // Validaciones
            if (nombre == null || nombre.isEmpty()
                    || apellido == null || apellido.isEmpty()
                    || dniRuc == null || dniRuc.isEmpty()) {

                request.setAttribute("mensaje", "❌ Error: Nombre, Apellido y DNI/RUC son obligatorios");
                request.getRequestDispatcher("InsertarCliente.jsp").forward(request, response);
                return;
            }

            // Crear cliente
            Cliente cliente = new Cliente(nombre, apellido, dniRuc, email, telefono, direccion, preferencias);

            // Insertar
            ClienteDao cd = new ClienteDao();
            boolean exito = cd.insertarCliente(cliente);

            if (exito) {
                request.setAttribute("mensaje", "✅ Cliente insertado con éxito");
            } else {
                request.setAttribute("mensaje", "❌ Error al insertar cliente. Posible DNI/RUC duplicado.");
            }

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error del sistema: " + e.getMessage());
        }

        request.getRequestDispatcher("InsertarCliente.jsp").forward(request, response);
    }

    // NUEVO MÉTODO: Buscar clientes
    private void buscarClientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String termino = request.getParameter("termino");

            if (termino == null || termino.trim().isEmpty()) {
                request.setAttribute("mensaje", "🔍 Ingrese un término de búsqueda");
                request.getRequestDispatcher("BuscarClientes.jsp").forward(request, response);
                return;
            }

            ClienteDao dao = new ClienteDao();
            List<Cliente> clientes = dao.buscarClientes(termino.trim());

            request.setAttribute("clientes", clientes);
            request.setAttribute("terminoBusqueda", termino);
            request.setAttribute("totalResultados", clientes.size());

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al buscar clientes: " + e.getMessage());
        }

        request.getRequestDispatcher("BuscarClientes.jsp").forward(request, response);
    }

    // NUEVO MÉTODO: Listar clientes frecuentes
    private void listarClientesFrecuentes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ClienteDao dao = new ClienteDao();
            List<ClienteFrecuenteDTO> clientesFrecuentes = dao.clientesFrecuentes();

            request.setAttribute("clientesFrecuentes", clientesFrecuentes);
            request.setAttribute("totalClientes", clientesFrecuentes.size());

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al cargar clientes frecuentes: " + e.getMessage());
        }

        request.getRequestDispatcher("ClientesFrecuentes.jsp").forward(request, response);
    }

    private void listarTodosClientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("=== CARGANDO CLIENTES DESDE SERVLET ===");

            ClienteDao dao = new ClienteDao();
            List<Cliente> todosClientes = dao.buscarClientes("");

            System.out.println("Clientes obtenidos: " + (todosClientes != null ? todosClientes.size() : "null"));

            // ESTO ES LO MÁS IMPORTANTE - asegurar que los datos lleguen al JSP
            request.setAttribute("clientes", todosClientes);
            request.setAttribute("totalClientes", todosClientes != null ? todosClientes.size() : 0);

            System.out.println("Atributos establecidos - redirigiendo a ListaClientes.jsp");

        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();

            // En caso de error, enviar lista vacía
            request.setAttribute("clientes", new ArrayList<Cliente>());
            request.setAttribute("totalClientes", 0);
            request.setAttribute("mensaje", "❌ Error al cargar clientes");
        }

        // Asegúrate de que esto diga EXACTAMENTE "ListaClientes.jsp"
        request.getRequestDispatcher("ListaClientes.jsp").forward(request, response);
    }

    // Método auxiliar para limpiar parámetros (ya existente)
    private String limpiarParametro(String param) {
        if (param == null) {
            return "";
        }
        return param.trim();
    }

    // MÉTODO TEMPORAL PARA DEBUG
    private void debugClientes() {
        try {
            ClienteDao dao = new ClienteDao();

            // Probar diferentes métodos
            List<Cliente> conBusquedaVacia = dao.buscarClientes("");
            List<Cliente> conPorcentaje = dao.buscarClientes("%");
            List<Cliente> conListarTodos = dao.listarTodosClientes();

            System.out.println("=== DEBUG CLIENTES ===");
            System.out.println("buscarClientes(''): " + (conBusquedaVacia != null ? conBusquedaVacia.size() : "null"));
            System.out.println("buscarClientes('%'): " + (conPorcentaje != null ? conPorcentaje.size() : "null"));
            System.out.println("listarTodosClientes(): " + (conListarTodos != null ? conListarTodos.size() : "null"));

        } catch (Exception e) {
            System.out.println("Error en debug: " + e.getMessage());
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
        return "Controlador para gestión completa de clientes";
    }
}
