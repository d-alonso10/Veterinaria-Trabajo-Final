package modelo;

import java.sql.Timestamp;

public class UsuarioSistema {
    private int idUsuario;
    private String nombre;
    private String rol;
    private String email;
    private String passwordHash;
    private java.sql.Timestamp createdAt;
    private java.sql.Timestamp updatedAt;

    public UsuarioSistema() {}

    public UsuarioSistema(int idUsuario, String nombre, String rol, String email, String passwordHash, java.sql.Timestamp createdAt, java.sql.Timestamp updatedAt) {
        this.idUsuario = idUsuario;
        this.nombre = nombre;
        this.rol = rol;
        this.email = email;
        this.passwordHash = passwordHash;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
    public java.sql.Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(java.sql.Timestamp updatedAt) { this.updatedAt = updatedAt; }
}