using Microsoft.EntityFrameworkCore;
using SmartLocker.Data;
using System.Configuration;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
//builder.Services.AddDbContext<SmartLockerContext>(options =>
    //options.UseMySQL("Server=localhost;port=3307;Database=smart-locker;User Id=root;Password=0979620120@Hau;", mysqlOptions => mysqlOptions.EnableRetryOnFailure()));
builder.Services.AddDbContext<SmartLockerContext>(options =>
    options.UseMySQL("Server=localhost;port=3306;Database=smart-locker;User Id=root;Password=123456;", mysqlOptions => mysqlOptions.EnableRetryOnFailure()));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
