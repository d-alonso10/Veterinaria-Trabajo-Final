package modelo;

public class ServicioPopularDTO {
    private String nombreServicio;
    private int vecesSolicitado;
    
    public ServicioPopularDTO() {}

    public ServicioPopularDTO(String nombreServicio, int vecesSolicitado) {
        this.nombreServicio = nombreServicio;
        this.vecesSolicitado = vecesSolicitado;
    }

    // Getters y Setters
    public String getNombreServicio() { return nombreServicio; }
    public void setNombreServicio(String nombreServicio) { this.nombreServicio = nombreServicio; }
    
    public int getVecesSolicitado() { return vecesSolicitado; }
    public void setVecesSolicitado(int vecesSolicitado) { this.vecesSolicitado = vecesSolicitado; }
}