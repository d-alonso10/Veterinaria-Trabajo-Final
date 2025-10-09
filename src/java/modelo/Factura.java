package modelo;

import java.sql.Timestamp;

public class Factura {
    private int idFactura;
    private String serie;
    private String numero;
    private int idCliente;
    private int idAtencion;
    private java.sql.Timestamp fechaEmision;
    private double subtotal;
    private double impuesto;
    private double descuentoTotal;
    private double total;
    private String estado;
    private String metodoPagoSugerido;

    public Factura() {}

    public Factura(int idFactura, String serie, String numero, int idCliente, int idAtencion, java.sql.Timestamp fechaEmision, double subtotal, double impuesto, double descuentoTotal, double total, String estado, String metodoPagoSugerido) {
        this.idFactura = idFactura;
        this.serie = serie;
        this.numero = numero;
        this.idCliente = idCliente;
        this.idAtencion = idAtencion;
        this.fechaEmision = fechaEmision;
        this.subtotal = subtotal;
        this.impuesto = impuesto;
        this.descuentoTotal = descuentoTotal;
        this.total = total;
        this.estado = estado;
        this.metodoPagoSugerido = metodoPagoSugerido;
    }

    public int getIdFactura() { return idFactura; }
    public void setIdFactura(int idFactura) { this.idFactura = idFactura; }
    public String getSerie() { return serie; }
    public void setSerie(String serie) { this.serie = serie; }
    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    public int getIdAtencion() { return idAtencion; }
    public void setIdAtencion(int idAtencion) { this.idAtencion = idAtencion; }
    public java.sql.Timestamp getFechaEmision() { return fechaEmision; }
    public void setFechaEmision(java.sql.Timestamp fechaEmision) { this.fechaEmision = fechaEmision; }
    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
    public double getImpuesto() { return impuesto; }
    public void setImpuesto(double impuesto) { this.impuesto = impuesto; }
    public double getDescuentoTotal() { return descuentoTotal; }
    public void setDescuentoTotal(double descuentoTotal) { this.descuentoTotal = descuentoTotal; }
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getMetodoPagoSugerido() { return metodoPagoSugerido; }
    public void setMetodoPagoSugerido(String metodoPagoSugerido) { this.metodoPagoSugerido = metodoPagoSugerido; }
}
