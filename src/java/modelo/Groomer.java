package modelo;

import java.sql.Timestamp;

public class Groomer {
    private int idGroomer;
    private String nombre;
    private String especialidades;
    private String disponibilidad;
    private java.sql.Timestamp createdAt;
    private java.sql.Timestamp updatedAt;

    public Groomer() {}

    public Groomer(int idGroomer, String nombre, String especialidades, String disponibilidad, java.sql.Timestamp createdAt, java.sql.Timestamp updatedAt) {
        this.idGroomer = idGroomer;
        this.nombre = nombre;
        this.especialidades = especialidades;
        this.disponibilidad = disponibilidad;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getIdGroomer() { return idGroomer; }
    public void setIdGroomer(int idGroomer) { this.idGroomer = idGroomer; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getEspecialidades() { return especialidades; }
    public void setEspecialidades(String especialidades) { this.especialidades = especialidades; }
    public String getDisponibilidad() { return disponibilidad; }
    public void setDisponibilidad(String disponibilidad) { this.disponibilidad = disponibilidad; }
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
    public java.sql.Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(java.sql.Timestamp updatedAt) { this.updatedAt = updatedAt; }
}