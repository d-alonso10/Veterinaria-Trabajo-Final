package modelo;

import java.sql.Date;

public class ReporteIngresosDTO {
    private Date fecha;
    private int cantidadFacturas;
    private double ingresosTotales;
    private double promedioPorFactura;

    // Getters y Setters
    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }
    public int getCantidadFacturas() { return cantidadFacturas; }
    public void setCantidadFacturas(int cantidadFacturas) { this.cantidadFacturas = cantidadFacturas; }
    public double getIngresosTotales() { return ingresosTotales; }
    public void setIngresosTotales(double ingresosTotales) { this.ingresosTotales = ingresosTotales; }
    public double getPromedioPorFactura() { return promedioPorFactura; }
    public void setPromedioPorFactura(double promedioPorFactura) { this.promedioPorFactura = promedioPorFactura; }
}