package modelo;

import java.sql.Timestamp;

public class FacturaClienteDTO {
    private int idFactura;
    private String serie;
    private String numero;
    private Timestamp fechaEmision;
    private double total;
    private String estado;
    
    public FacturaClienteDTO() {}

    public FacturaClienteDTO(int idFactura, String serie, String numero, 
                           Timestamp fechaEmision, double total, String estado) {
        this.idFactura = idFactura;
        this.serie = serie;
        this.numero = numero;
        this.fechaEmision = fechaEmision;
        this.total = total;
        this.estado = estado;
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
    
    // Método auxiliar para obtener número completo de factura
    public String getNumeroFactura() {
        if (serie != null && numero != null) {
            return serie + "-" + numero;
        } else if (numero != null) {
            return numero;
        }
        return "";
    }
}