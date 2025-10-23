package modelo;

import java.sql.Timestamp;

public class NotificacionClienteDTO {
    private int idNotificacion;
    private String tipo;
    private String contenido;
    private Timestamp fechaCreacion;  // Campo fecha_creacion de la BD
    private Timestamp enviadoAt;
    private String estado;
    private String referenciaTipo;
    private int referenciaId;
    
    // Campos del cliente (JOIN)
    private String nombreCliente;
    private String apellidoCliente;

    // Getters y Setters
    public int getIdNotificacion() { return idNotificacion; }
    public void setIdNotificacion(int idNotificacion) { this.idNotificacion = idNotificacion; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public String getContenido() { return contenido; }
    public void setContenido(String contenido) { this.contenido = contenido; }
    public Timestamp getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(Timestamp fechaCreacion) { this.fechaCreacion = fechaCreacion; }
    public Timestamp getEnviadoAt() { return enviadoAt; }
    public void setEnviadoAt(Timestamp enviadoAt) { this.enviadoAt = enviadoAt; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getReferenciaTipo() { return referenciaTipo; }
    public void setReferenciaTipo(String referenciaTipo) { this.referenciaTipo = referenciaTipo; }
    public int getReferenciaId() { return referenciaId; }
    public void setReferenciaId(int referenciaId) { this.referenciaId = referenciaId; }
    
    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }
    public String getApellidoCliente() { return apellidoCliente; }
    public void setApellidoCliente(String apellidoCliente) { this.apellidoCliente = apellidoCliente; }
    
    // Método auxiliar para obtener nombre completo del cliente
    public String getNombreCompletoCliente() {
        if (nombreCliente != null && apellidoCliente != null) {
            return nombreCliente + " " + apellidoCliente;
        } else if (nombreCliente != null) {
            return nombreCliente;
        }
        return "Sistema";  // Para notificaciones del sistema
    }
}