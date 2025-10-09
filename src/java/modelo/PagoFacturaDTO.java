package modelo;

import java.sql.Timestamp;

public class PagoFacturaDTO {
    private int idPago;
    private Timestamp fechaPago;
    private double monto;
    private String metodo;
    private String estado;
    
    public PagoFacturaDTO() {}

    public PagoFacturaDTO(int idPago, Timestamp fechaPago, double monto, String metodo, String estado) {
        this.idPago = idPago;
        this.fechaPago = fechaPago;
        this.monto = monto;
        this.metodo = metodo;
        this.estado = estado;
    }

    // Getters y Setters
    public int getIdPago() { return idPago; }
    public void setIdPago(int idPago) { this.idPago = idPago; }
    
    public Timestamp getFechaPago() { return fechaPago; }
    public void setFechaPago(Timestamp fechaPago) { this.fechaPago = fechaPago; }
    
    public double getMonto() { return monto; }
    public void setMonto(double monto) { this.monto = monto; }
    
    public String getMetodo() { return metodo; }
    public void setMetodo(String metodo) { this.metodo = metodo; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}