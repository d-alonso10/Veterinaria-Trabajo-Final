package modelo;

import java.sql.Date;

public class Promocion {
    private int idPromocion;
    private String nombre;
    private String descripcion;
    private String tipo;
    private double valor;
    private java.sql.Date fechaInicio;
    private java.sql.Date fechaFin;
    private String estado;

    public Promocion() {}

    public Promocion(int idPromocion, String nombre, String descripcion, String tipo, double valor, java.sql.Date fechaInicio, java.sql.Date fechaFin, String estado) {
        this.idPromocion = idPromocion;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.tipo = tipo;
        this.valor = valor;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.estado = estado;
    }

    public int getIdPromocion() { return idPromocion; }
    public void setIdPromocion(int idPromocion) { this.idPromocion = idPromocion; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public double getValor() { return valor; }
    public void setValor(double valor) { this.valor = valor; }
    public java.sql.Date getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(java.sql.Date fechaInicio) { this.fechaInicio = fechaInicio; }
    public java.sql.Date getFechaFin() { return fechaFin; }
    public void setFechaFin(java.sql.Date fechaFin) { this.fechaFin = fechaFin; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}
