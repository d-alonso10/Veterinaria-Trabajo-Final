package modelo;

public class OcupacionGroomerDTO {
    private String nombreGroomer;
    private int atencionesRealizadas;
    private int minutosTrabajados;
    private double porcentajeOcupacion;

    // Getters y Setters
    public String getNombreGroomer() { return nombreGroomer; }
    public void setNombreGroomer(String nombreGroomer) { this.nombreGroomer = nombreGroomer; }
    public int getAtencionesRealizadas() { return atencionesRealizadas; }
    public void setAtencionesRealizadas(int atencionesRealizadas) { this.atencionesRealizadas = atencionesRealizadas; }
    public int getMinutosTrabajados() { return minutosTrabajados; }
    public void setMinutosTrabajados(int minutosTrabajados) { this.minutosTrabajados = minutosTrabajados; }
    public double getPorcentajeOcupacion() { return porcentajeOcupacion; }
    public void setPorcentajeOcupacion(double porcentajeOcupacion) { this.porcentajeOcupacion = porcentajeOcupacion; }
    
    // Métodos auxiliares
    public double getHorasTrabajadas() {
        return Math.round((minutosTrabajados / 60.0) * 100.0) / 100.0;
    }
    
    public String getNivelOcupacion() {
        if (porcentajeOcupacion >= 90) return "Muy Alta";
        else if (porcentajeOcupacion >= 75) return "Alta";
        else if (porcentajeOcupacion >= 60) return "Media";
        else if (porcentajeOcupacion >= 40) return "Baja";
        else return "Muy Baja";
    }
}