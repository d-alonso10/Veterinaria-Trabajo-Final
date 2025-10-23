import dao.FacturaDao;
import modelo.Factura;
import java.sql.Timestamp;
import java.util.List;

public class PruebaFacturaDao {
    public static void main(String[] args) {
        FacturaDao facturaDao = new FacturaDao();
        
        System.out.println("=== PRUEBAS FacturaDao ===");
        
        // 1. Prueba obtenerFacturaPorId
        System.out.println("\n1. Probando obtenerFacturaPorId(1):");
        Factura factura = facturaDao.obtenerFacturaPorId(1);
        if (factura != null) {
            System.out.println("✅ Factura encontrada: " + factura.getSerie() + "-" + factura.getNumero());
            System.out.println("   Cliente ID: " + factura.getIdCliente());
            System.out.println("   Total: $" + factura.getTotal());
            System.out.println("   Estado: " + factura.getEstado());
        } else {
            System.out.println("❌ No se encontró factura con ID 1");
        }
        
        // 2. Prueba listarTodasFacturas
        System.out.println("\n2. Probando listarTodasFacturas():");
        List<Factura> todasFacturas = facturaDao.listarTodasFacturas();
        System.out.println("✅ Total de facturas: " + todasFacturas.size());
        if (!todasFacturas.isEmpty()) {
            System.out.println("   Primera factura: " + todasFacturas.get(0).getSerie() + "-" + todasFacturas.get(0).getNumero());
        }
        
        // 3. Prueba obtenerFacturasPorEstado
        System.out.println("\n3. Probando obtenerFacturasPorEstado('emitida'):");
        List<Factura> facturasEmitidas = facturaDao.obtenerFacturasPorEstado("emitida");
        System.out.println("✅ Facturas emitidas: " + facturasEmitidas.size());
        
        // 4. Prueba buscarFacturas
        System.out.println("\n4. Probando buscarFacturas('001'):");
        List<Factura> facturasBuscadas = facturaDao.buscarFacturas("001");
        System.out.println("✅ Facturas encontradas: " + facturasBuscadas.size());
        
        // 5. Prueba obtenerFacturasPorFecha
        System.out.println("\n5. Probando obtenerFacturasPorFecha (últimos 30 días):");
        Timestamp fechaInicio = new Timestamp(System.currentTimeMillis() - (30L * 24 * 60 * 60 * 1000));
        Timestamp fechaFin = new Timestamp(System.currentTimeMillis());
        List<Factura> facturasPorFecha = facturaDao.obtenerFacturasPorFecha(fechaInicio, fechaFin);
        System.out.println("✅ Facturas en los últimos 30 días: " + facturasPorFecha.size());
        
        System.out.println("\n=== TODAS LAS PRUEBAS COMPLETADAS ===");
    }
}