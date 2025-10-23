package modelo;

import java.sql.Timestamp;

public class AtencionColaDTO {
    private int idAtencion;
    private int idMascota;
    private int idCliente;
    private String nombreMascota;
    private String nombreCliente;
    private String nombreGroomer;
    private String estado;
    private int turnoNum;
    private Timestamp tiempoEstimadoInicio;
    private Timestamp tiempoEstimadoFin;
    private int prioridad;
    
    public AtencionColaDTO() {}

    public AtencionColaDTO(int idAtencion, int idMascota, int idCliente, String nombreMascota, 
                          String nombreCliente, String nombreGroomer, String estado, int turnoNum, 
                          Timestamp tiempoEstimadoInicio, Timestamp tiempoEstimadoFin, int prioridad) {
        this.idAtencion = idAtencion;
        this.idMascota = idMascota;
        this.idCliente = idCliente;
        this.nombreMascota = nombreMascota;
        this.nombreCliente = nombreCliente;
        this.nombreGroomer = nombreGroomer;
        this.estado = estado;
        this.turnoNum = turnoNum;
        this.tiempoEstimadoInicio = tiempoEstimadoInicio;
        this.tiempoEstimadoFin = tiempoEstimadoFin;
        this.prioridad = prioridad;
    }

    // Getters y Setters
    public int getIdAtencion() { return idAtencion; }
    public void setIdAtencion(int idAtencion) { this.idAtencion = idAtencion; }
    
    public int getIdMascota() { return idMascota; }
    public void setIdMascota(int idMascota) { this.idMascota = idMascota; }
    
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    
    public String getNombreMascota() { return nombreMascota; }
    public void setNombreMascota(String nombreMascota) { this.nombreMascota = nombreMascota; }
    
    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }
    
    public String getNombreGroomer() { return nombreGroomer; }
    public void setNombreGroomer(String nombreGroomer) { this.nombreGroomer = nombreGroomer; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public int getTurnoNum() { return turnoNum; }
    public void setTurnoNum(int turnoNum) { this.turnoNum = turnoNum; }
    
    public Timestamp getTiempoEstimadoInicio() { return tiempoEstimadoInicio; }
    public void setTiempoEstimadoInicio(Timestamp tiempoEstimadoInicio) { this.tiempoEstimadoInicio = tiempoEstimadoInicio; }
    
    public Timestamp getTiempoEstimadoFin() { return tiempoEstimadoFin; }
    public void setTiempoEstimadoFin(Timestamp tiempoEstimadoFin) { this.tiempoEstimadoFin = tiempoEstimadoFin; }
    
    public int getPrioridad() { return prioridad; }
    public void setPrioridad(int prioridad) { this.prioridad = prioridad; }
}