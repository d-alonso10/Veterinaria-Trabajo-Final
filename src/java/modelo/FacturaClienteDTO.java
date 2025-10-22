package modelo;

import java.sql.Timestamp;

public class FacturaClienteDTO {
    private int idFactura;
    private String serie;
    private String numero;
    private int idCliente;
    private int idAtencion;
    private Timestamp fechaEmision;
    private double subtotal;
    private double impuesto;
    private double descuentoTotal;
    private double total;
    private String estado;
    private String metodoPagoSugerido;
    
    // Campos del cliente (JOIN)
    private String nombreCliente;
    private String apellidoCliente;
    
    public FacturaClienteDTO() {}

    public FacturaClienteDTO(int idFactura, String serie, String numero, int idCliente, int idAtencion,
                           Timestamp fechaEmision, double subtotal, double impuesto, double descuentoTotal, 
                           double total, String estado, String metodoPagoSugerido, 
                           String nombreCliente, String apellidoCliente) {
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
        this.nombreCliente = nombreCliente;
        this.apellidoCliente = apellidoCliente;
    }

    // Getters y Setters
    public int getIdFactura() { return idFactura; }
    public void setIdFactura(int idFactura) { this.idFactura = idFactura; }
    
    public String getSerie() { return serie; }
    public void setSerie(String serie) { this.serie = serie; }
    
    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }
    
    public Timestamp getFechaEmision() { return fechaEmision; }
    public void setFechaEmision(Timestamp fechaEmision) { this.fechaEmision = fechaEmision; }
    
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    
    public int getIdAtencion() { return idAtencion; }
    public void setIdAtencion(int idAtencion) { this.idAtencion = idAtencion; }
    
    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
    
    public double getImpuesto() { return impuesto; }
    public void setImpuesto(double impuesto) { this.impuesto = impuesto; }
    
    public double getDescuentoTotal() { return descuentoTotal; }
    public void setDescuentoTotal(double descuentoTotal) { this.descuentoTotal = descuentoTotal; }
    
    public String getMetodoPagoSugerido() { return metodoPagoSugerido; }
    public void setMetodoPagoSugerido(String metodoPagoSugerido) { this.metodoPagoSugerido = metodoPagoSugerido; }
    
    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }
    
    public String getApellidoCliente() { return apellidoCliente; }
    public void setApellidoCliente(String apellidoCliente) { this.apellidoCliente = apellidoCliente; }
    
    // Método auxiliar para obtener número completo de factura
    public String getNumeroFactura() {
        if (serie != null && numero != null) {
            return serie + "-" + numero;
        } else if (numero != null) {
            return numero;
        }
        return "";
    }
    
    // Método auxiliar para obtener nombre completo del cliente
    public String getNombreCompletoCliente() {
        if (nombreCliente != null && apellidoCliente != null) {
            return nombreCliente + " " + apellidoCliente;
        } else if (nombreCliente != null) {
            return nombreCliente;
        }
        return "";
    }
}