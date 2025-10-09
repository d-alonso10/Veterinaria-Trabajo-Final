package modelo;

import java.sql.Timestamp;

public class Cliente {

    private int idCliente;
    private String nombre;
    private String apellido;
    private String dniRuc;
    private String email;
    private String telefono;
    private String direccion;
    private String preferencias;
    private java.sql.Timestamp createdAt;
    private java.sql.Timestamp updatedAt;

    public Cliente() {
    }

    public Cliente(String nombre, String apellido, String dniRuc, String email, String telefono, String direccion, String preferencias) {
        this.nombre = nombre;
        this.apellido = apellido;
        this.dniRuc = dniRuc;
        this.email = email;
        this.telefono = telefono;
        this.direccion = direccion;
        this.preferencias = preferencias;
    }
    
    

    public Cliente(int idCliente, String nombre, String apellido, String dniRuc, String email, String telefono, String direccion, String preferencias, java.sql.Timestamp createdAt, java.sql.Timestamp updatedAt) {
        this.idCliente = idCliente;
        this.nombre = nombre;
        this.apellido = apellido;
        this.dniRuc = dniRuc;
        this.email = email;
        this.telefono = telefono;
        this.direccion = direccion;
        this.preferencias = preferencias;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getDniRuc() {
        return dniRuc;
    }

    public void setDniRuc(String dniRuc) {
        this.dniRuc = dniRuc;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getPreferencias() {
        return preferencias;
    }

    public void setPreferencias(String preferencias) {
        this.preferencias = preferencias;
    }

    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public java.sql.Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(java.sql.Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
