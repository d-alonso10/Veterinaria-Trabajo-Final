package modelo;

import java.sql.Timestamp;

public class AtencionColaDTO {
    private int idAtencion;
    private String nombreMascota;
    private String nombreGroomer;
    private String estado;
    private int turnoNum;
    private Timestamp tiempoEstimadoInicio;
    
    public AtencionColaDTO() {}

    public AtencionColaDTO(int idAtencion, String nombreMascota, String nombreGroomer, 
                          String estado, int turnoNum, Timestamp tiempoEstimadoInicio) {
        this.idAtencion = idAtencion;
        this.nombreMascota = nombreMascota;
        this.nombreGroomer = nombreGroomer;
        this.estado = estado;
        this.turnoNum = turnoNum;
        this.tiempoEstimadoInicio = tiempoEstimadoInicio;
    }

    // Getters y Setters
    public int getIdAtencion() { return idAtencion; }
    public void setIdAtencion(int idAtencion) { this.idAtencion = idAtencion; }
    
    public String getNombreMascota() { return nombreMascota; }
    public void setNombreMascota(String nombreMascota) { this.nombreMascota = nombreMascota; }
    
    public String getNombreGroomer() { return nombreGroomer; }
    public void setNombreGroomer(String nombreGroomer) { this.nombreGroomer = nombreGroomer; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public int getTurnoNum() { return turnoNum; }
    public void setTurnoNum(int turnoNum) { this.turnoNum = turnoNum; }
    
    public Timestamp getTiempoEstimadoInicio() { return tiempoEstimadoInicio; }
    public void setTiempoEstimadoInicio(Timestamp tiempoEstimadoInicio) { this.tiempoEstimadoInicio = tiempoEstimadoInicio; }
}