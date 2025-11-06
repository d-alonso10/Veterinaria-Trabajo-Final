package modelo;

import java.sql.Date;

// Modelo principal para la tabla 'mascota'
public class Mascota {
    private int idMascota;
    private int idCliente;
    private String nombre;
    private String especie;
    private String raza;
    private String sexo;
    private java.sql.Date fechaNacimiento;
    private String microchip;
    private String observaciones;

    public Mascota() {}

    // Getters y Setters
    public int getIdMascota() { return idMascota; }
    public void setIdMascota(int idMascota) { this.idMascota = idMascota; }
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getEspecie() { return especie; }
    public void setEspecie(String especie) { this.especie = especie; }
    public String getRaza() { return raza; }
    public void setRaza(String raza) { this.raza = raza; }
    public String getSexo() { return sexo; }
    public void setSexo(String sexo) { this.sexo = sexo; }
    public java.sql.Date getFechaNacimiento() { return fechaNacimiento; }
    public void setFechaNacimiento(java.sql.Date fechaNacimiento) { this.fechaNacimiento = fechaNacimiento; }
    public String getMicrochip() { return microchip; }
    public void setMicrochip(String microchip) { this.microchip = microchip; }
    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
}