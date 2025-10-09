package modelo;

import java.sql.Timestamp;

public class PaqueteServicio {
    private int idPaquete;
    private String nombre;
    private String descripcion;
    private double precioTotal;
    private java.sql.Timestamp createdAt;
    private java.sql.Timestamp updatedAt;

    public PaqueteServicio() {}

    public PaqueteServicio(int idPaquete, String nombre, String descripcion, double precioTotal, java.sql.Timestamp createdAt, java.sql.Timestamp updatedAt) {
        this.idPaquete = idPaquete;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.precioTotal = precioTotal;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getIdPaquete() { return idPaquete; }
    public void setIdPaquete(int idPaquete) { this.idPaquete = idPaquete; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public double getPrecioTotal() { return precioTotal; }
    public void setPrecioTotal(double precioTotal) { this.precioTotal = precioTotal; }
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
    public java.sql.Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(java.sql.Timestamp updatedAt) { this.updatedAt = updatedAt; }
}