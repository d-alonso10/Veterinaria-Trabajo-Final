package modelo;

import java.sql.Timestamp;

public class Servicio {
    private int idServicio;
    private String codigo;
    private String nombre;
    private String descripcion;
    private int duracionEstimadaMin;
    private double precioBase;
    private String categoria;
    private java.sql.Timestamp createdAt;
    private java.sql.Timestamp updatedAt;

    public Servicio() {}

    public Servicio(int idServicio, String codigo, String nombre, String descripcion, int duracionEstimadaMin, double precioBase, String categoria, java.sql.Timestamp createdAt, java.sql.Timestamp updatedAt) {
        this.idServicio = idServicio;
        this.codigo = codigo;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.duracionEstimadaMin = duracionEstimadaMin;
        this.precioBase = precioBase;
        this.categoria = categoria;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getIdServicio() { return idServicio; }
    public void setIdServicio(int idServicio) { this.idServicio = idServicio; }
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public int getDuracionEstimadaMin() { return duracionEstimadaMin; }
    public void setDuracionEstimadaMin(int duracionEstimadaMin) { this.duracionEstimadaMin = duracionEstimadaMin; }
    public double getPrecioBase() { return precioBase; }
    public void setPrecioBase(double precioBase) { this.precioBase = precioBase; }
    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
    public java.sql.Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(java.sql.Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
