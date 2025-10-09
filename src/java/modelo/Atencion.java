package modelo;

import java.sql.Timestamp;

public class Atencion {
    private int idAtencion;
    private int idCita;
    private int idMascota;
    private int idCliente;
    private int idGroomer;
    private int idSucursal;
    private String estado;
    private int turnoNum;
    private java.sql.Timestamp tiempoEstimadoInicio;
    private java.sql.Timestamp tiempoEstimadoFin;
    private java.sql.Timestamp tiempoRealInicio;
    private java.sql.Timestamp tiempoRealFin;
    private int prioridad;
    private String observaciones;
    private java.sql.Timestamp createdAt;
    private java.sql.Timestamp updatedAt;

    public Atencion() {}

    public Atencion(int idAtencion, int idCita, int idMascota, int idCliente, int idGroomer, int idSucursal, String estado, int turnoNum, java.sql.Timestamp tiempoEstimadoInicio, java.sql.Timestamp tiempoEstimadoFin, java.sql.Timestamp tiempoRealInicio, java.sql.Timestamp tiempoRealFin, int prioridad, String observaciones, java.sql.Timestamp createdAt, java.sql.Timestamp updatedAt) {
        this.idAtencion = idAtencion;
        this.idCita = idCita;
        this.idMascota = idMascota;
        this.idCliente = idCliente;
        this.idGroomer = idGroomer;
        this.idSucursal = idSucursal;
        this.estado = estado;
        this.turnoNum = turnoNum;
        this.tiempoEstimadoInicio = tiempoEstimadoInicio;
        this.tiempoEstimadoFin = tiempoEstimadoFin;
        this.tiempoRealInicio = tiempoRealInicio;
        this.tiempoRealFin = tiempoRealFin;
        this.prioridad = prioridad;
        this.observaciones = observaciones;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getIdAtencion() { return idAtencion; }
    public void setIdAtencion(int idAtencion) { this.idAtencion = idAtencion; }
    public int getIdCita() { return idCita; }
    public void setIdCita(int idCita) { this.idCita = idCita; }
    public int getIdMascota() { return idMascota; }
    public void setIdMascota(int idMascota) { this.idMascota = idMascota; }
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    public int getIdGroomer() { return idGroomer; }
    public void setIdGroomer(int idGroomer) { this.idGroomer = idGroomer; }
    public int getIdSucursal() { return idSucursal; }
    public void setIdSucursal(int idSucursal) { this.idSucursal = idSucursal; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public int getTurnoNum() { return turnoNum; }
    public void setTurnoNum(int turnoNum) { this.turnoNum = turnoNum; }
    public java.sql.Timestamp getTiempoEstimadoInicio() { return tiempoEstimadoInicio; }
    public void setTiempoEstimadoInicio(java.sql.Timestamp tiempoEstimadoInicio) { this.tiempoEstimadoInicio = tiempoEstimadoInicio; }
    public java.sql.Timestamp getTiempoEstimadoFin() { return tiempoEstimadoFin; }
    public void setTiempoEstimadoFin(java.sql.Timestamp tiempoEstimadoFin) { this.tiempoEstimadoFin = tiempoEstimadoFin; }
    public java.sql.Timestamp getTiempoRealInicio() { return tiempoRealInicio; }
    public void setTiempoRealInicio(java.sql.Timestamp tiempoRealInicio) { this.tiempoRealInicio = tiempoRealInicio; }
    public java.sql.Timestamp getTiempoRealFin() { return tiempoRealFin; }
    public void setTiempoRealFin(java.sql.Timestamp tiempoRealFin) { this.tiempoRealFin = tiempoRealFin; }
    public int getPrioridad() { return prioridad; }
    public void setPrioridad(int prioridad) { this.prioridad = prioridad; }
    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
    public java.sql.Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(java.sql.Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
