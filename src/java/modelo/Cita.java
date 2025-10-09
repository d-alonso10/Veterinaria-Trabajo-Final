package modelo;

import java.sql.Timestamp;

public class Cita {
    private int idCita;
    private int idMascota;
    private int idCliente;
    private int idSucursal;
    private int idServicio;
    private java.sql.Timestamp fechaProgramada;
    private String modalidad;
    private String estado;
    private String notas;
    private java.sql.Timestamp createdAt;
    private java.sql.Timestamp updatedAt;

    public Cita() {}

    public Cita(int idCita, int idMascota, int idCliente, int idSucursal, int idServicio, java.sql.Timestamp fechaProgramada, String modalidad, String estado, String notas, java.sql.Timestamp createdAt, java.sql.Timestamp updatedAt) {
        this.idCita = idCita;
        this.idMascota = idMascota;
        this.idCliente = idCliente;
        this.idSucursal = idSucursal;
        this.idServicio = idServicio;
        this.fechaProgramada = fechaProgramada;
        this.modalidad = modalidad;
        this.estado = estado;
        this.notas = notas;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getIdCita() { return idCita; }
    public void setIdCita(int idCita) { this.idCita = idCita; }
    public int getIdMascota() { return idMascota; }
    public void setIdMascota(int idMascota) { this.idMascota = idMascota; }
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    public int getIdSucursal() { return idSucursal; }
    public void setIdSucursal(int idSucursal) { this.idSucursal = idSucursal; }
    public int getIdServicio() { return idServicio; }
    public void setIdServicio(int idServicio) { this.idServicio = idServicio; }
    public java.sql.Timestamp getFechaProgramada() { return fechaProgramada; }
    public void setFechaProgramada(java.sql.Timestamp fechaProgramada) { this.fechaProgramada = fechaProgramada; }
    public String getModalidad() { return modalidad; }
    public void setModalidad(String modalidad) { this.modalidad = modalidad; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getNotas() { return notas; }
    public void setNotas(String notas) { this.notas = notas; }
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
    public java.sql.Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(java.sql.Timestamp updatedAt) { this.updatedAt = updatedAt; }
}