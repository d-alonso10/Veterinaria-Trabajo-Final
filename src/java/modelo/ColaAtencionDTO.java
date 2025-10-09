package modelo;

import java.sql.Timestamp;

public class ColaAtencionDTO {
    private int idAtencion;
    private String mascota;
    private String cliente;
    private String groomer;
    private String estado;
    private int turnoNum;
    private Timestamp tiempoEstimadoInicio;
    private Timestamp tiempoEstimadoFin;

    public int getIdAtencion() { return idAtencion; }
    public void setIdAtencion(int idAtencion) { this.idAtencion = idAtencion; }
    public String getMascota() { return mascota; }
    public void setMascota(String mascota) { this.mascota = mascota; }
    public String getCliente() { return cliente; }
    public void setCliente(String cliente) { this.cliente = cliente; }
    public String getGroomer() { return groomer; }
    public void setGroomer(String groomer) { this.groomer = groomer; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public int getTurnoNum() { return turnoNum; }
    public void setTurnoNum(int turnoNum) { this.turnoNum = turnoNum; }
    public Timestamp getTiempoEstimadoInicio() { return tiempoEstimadoInicio; }
    public void setTiempoEstimadoInicio(Timestamp tiempoEstimadoInicio) { this.tiempoEstimadoInicio = tiempoEstimadoInicio; }
    public Timestamp getTiempoEstimadoFin() { return tiempoEstimadoFin; }
    public void setTiempoEstimadoFin(Timestamp tiempoEstimadoFin) { this.tiempoEstimadoFin = tiempoEstimadoFin; }
}