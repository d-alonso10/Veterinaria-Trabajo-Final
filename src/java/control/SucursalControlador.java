package control;

import dao.SucursalDao;
import modelo.Sucursal;
import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SucursalControlador")
public class SucursalControlador extends HttpServlet {

    private SucursalDao sucursalDao = new SucursalDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "listar":
                listarSucursales(request, response);
                break;
            case "editar":
                mostrarFormularioEditar(request, response);
                break;
            default:
                listarSucursales(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) accion = "";

        switch (accion) {
            case "insertar":
                insertarSucursal(request, response);
                break;
            case "actualizar":
                actualizarSucursal(request, response);
                break;
            default:
                listarSucursales(request, response);
                break;
        }
    }

    // =========================================================
    // MÉTODOS DE ACCIÓN
    // =========================================================

    private void listarSucursales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Sucursal> lista = sucursalDao.obtenerSucursales();
        request.setAttribute("sucursales", lista);
        RequestDispatcher dispatcher = request.getRequestDispatcher("SucursalListar.jsp");
        dispatcher.forward(request, response);
    }

    private void insertarSucursal(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String nombre = request.getParameter("nombre");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");

        Sucursal sucursal = new Sucursal();
        sucursal.setNombre(nombre);
        sucursal.setDireccion(direccion);
        sucursal.setTelefono(telefono);

        int idGenerado = sucursalDao.insertarSucursal(sucursal);

        if (idGenerado != -1) {
            request.setAttribute("mensaje", "✅ Sucursal registrada correctamente (ID: " + idGenerado + ")");
        } else {
            request.setAttribute("mensaje", "❌ Error al registrar la sucursal");
        }

        listarSucursales(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idSucursal = Integer.parseInt(request.getParameter("id"));
        List<Sucursal> lista = sucursalDao.obtenerSucursales();
        Sucursal sucursalEncontrada = lista.stream()
                .filter(s -> s.getIdSucursal() == idSucursal)
                .findFirst()
                .orElse(null);

        request.setAttribute("sucursal", sucursalEncontrada);
        RequestDispatcher dispatcher = request.getRequestDispatcher("SucursalEditar.jsp");
        dispatcher.forward(request, response);
    }

    private void actualizarSucursal(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        int idSucursal = Integer.parseInt(request.getParameter("idSucursal"));
        String nombre = request.getParameter("nombre");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");

        Sucursal sucursal = new Sucursal();
        sucursal.setIdSucursal(idSucursal);
        sucursal.setNombre(nombre);
        sucursal.setDireccion(direccion);
        sucursal.setTelefono(telefono);

        boolean exito = sucursalDao.actualizarSucursal(sucursal);

        if (exito) {
            request.setAttribute("mensaje", "✅ Sucursal actualizada correctamente.");
        } else {
            request.setAttribute("mensaje", "❌ Error al actualizar la sucursal.");
        }

        listarSucursales(request, response);
    }
}
