package modelo;

public class EstadisticasMensualesDTO {
    private double totalFacturado;
    private int clientesNuevos;
    private int atencionesRealizadas;
    private String servicioPopular;

    public EstadisticasMensualesDTO() {}

    public EstadisticasMensualesDTO(double totalFacturado, int clientesNuevos, int atencionesRealizadas, String servicioPopular) {
        this.totalFacturado = totalFacturado;
        this.clientesNuevos = clientesNuevos;
        this.atencionesRealizadas = atencionesRealizadas;
        this.servicioPopular = servicioPopular;
    }

    // Getters y Setters
    public double getTotalFacturado() { return totalFacturado; }
    public void setTotalFacturado(double totalFacturado) { this.totalFacturado = totalFacturado; }
    public int getClientesNuevos() { return clientesNuevos; }
    public void setClientesNuevos(int clientesNuevos) { this.clientesNuevos = clientesNuevos; }
    public int getAtencionesRealizadas() { return atencionesRealizadas; }
    public void setAtencionesRealizadas(int atencionesRealizadas) { this.atencionesRealizadas = atencionesRealizadas; }
    public String getServicioPopular() { return servicioPopular; }
    public void setServicioPopular(String servicioPopular) { this.servicioPopular = servicioPopular; }
}