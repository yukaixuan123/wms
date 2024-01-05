
using Microsoft.EntityFrameworkCore;
using WMS.AppService.AppService;
using WMS.AppService.Profiles;
using WMS.Domain.Repository;
using WMS.EFCore;
using WMS.EFCore.Repository;

namespace Authorizw
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            {
                //注册仓储
                builder.Services.AddScoped<IUsersAppService, UsersAppService>();
                builder.Services.AddScoped<IUsersRepository, UsersRepository>();
            }
            {
                //注册配置类
                builder.Services.AddAutoMapper(typeof(UsersProfiles));
            }

            builder.Services.AddDbContext<MyContext>(options =>
            {
                //读取连接字符串
                options.UseSqlServer(builder.Configuration.GetConnectionString("SqlConnection"));

                //全局取消实体状态跟踪
                options.UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking);
            });
            string[] urls = new[] { "http://localhost:8080" };
            builder.Services.AddCors(options =>
                options.AddDefaultPolicy(builder => builder.WithOrigins(urls)
                .AllowAnyMethod().AllowAnyHeader().AllowCredentials()));

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }
            app.UseCors();
            app.UseAuthentication();
            app.UseAuthorization();



            app.MapControllers();

            app.Run();
        }
    }
}