package modelo;

import java.sql.Timestamp;

public class Pago {
    private int idPago;
    private int idFactura;
    private java.sql.Timestamp fechaPago;
    private double monto;
    private String metodo;
    private String referencia;
    private String estado;

    public Pago() {}

    public Pago(int idPago, int idFactura, java.sql.Timestamp fechaPago, double monto, String metodo, String referencia, String estado) {
        this.idPago = idPago;
        this.idFactura = idFactura;
        this.fechaPago = fechaPago;
        this.monto = monto;
        this.metodo = metodo;
        this.referencia = referencia;
        this.estado = estado;
    }

    public int getIdPago() { return idPago; }
    public void setIdPago(int idPago) { this.idPago = idPago; }
    public int getIdFactura() { return idFactura; }
    public void setIdFactura(int idFactura) { this.idFactura = idFactura; }
    public java.sql.Timestamp getFechaPago() { return fechaPago; }
    public void setFechaPago(java.sql.Timestamp fechaPago) { this.fechaPago = fechaPago; }
    public double getMonto() { return monto; }
    public void setMonto(double monto) { this.monto = monto; }
    public String getMetodo() { return metodo; }
    public void setMetodo(String metodo) { this.metodo = metodo; }
    public String getReferencia() { return referencia; }
    public void setReferencia(String referencia) { this.referencia = referencia; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}
