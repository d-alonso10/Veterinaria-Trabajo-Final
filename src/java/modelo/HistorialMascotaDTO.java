package modelo;

import java.sql.Timestamp;

public class HistorialMascotaDTO {
    private int idAtencion;
    private Timestamp tiempoRealInicio;
    private Timestamp tiempoRealFin;
    private String groomer;
    private String sucursal;
    private String servicios;
    private double montoFacturado;

    // Getters y Setters
    public int getIdAtencion() { return idAtencion; }
    public void setIdAtencion(int idAtencion) { this.idAtencion = idAtencion; }
    public Timestamp getTiempoRealInicio() { return tiempoRealInicio; }
    public void setTiempoRealInicio(Timestamp tiempoRealInicio) { this.tiempoRealInicio = tiempoRealInicio; }
    public Timestamp getTiempoRealFin() { return tiempoRealFin; }
    public void setTiempoRealFin(Timestamp tiempoRealFin) { this.tiempoRealFin = tiempoRealFin; }
    public String getGroomer() { return groomer; }
    public void setGroomer(String groomer) { this.groomer = groomer; }
    public String getSucursal() { return sucursal; }
    public void setSucursal(String sucursal) { this.sucursal = sucursal; }
    public String getServicios() { return servicios; }
    public void setServicios(String servicios) { this.servicios = servicios; }
    public double getMontoFacturado() { return montoFacturado; }
    public void setMontoFacturado(double montoFacturado) { this.montoFacturado = montoFacturado; }
    
    // Método auxiliar para calcular duración
    public long getDuracion() {
        if (tiempoRealInicio != null && tiempoRealFin != null) {
            long diff = tiempoRealFin.getTime() - tiempoRealInicio.getTime();
            return diff / (60 * 1000); // Convertir a minutos
        }
        return 0;
    }
}