using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using InfluxDB.Collector;

namespace aspnetcoreapp
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            // Configure Metrics collector
            Metrics.Collector = new CollectorConfiguration()
                .Tag.With("Host", Environment.MachineName)
                .Batch.AtInterval(TimeSpan.FromSeconds(3))
                .WriteTo.InfluxDB("http://influxdb:8086", "myaspnetcoreapp", "foo", "bar")
                .CreateCollector();

            services.AddMvc();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
        {
            // // InfluxDB middleware
            // app.Use(next => async context =>
            // {
            //     Metrics.Increment("Requests");
            //     try
            //     {
            //         using (var time = Metrics.Time("Request"))
            //         {
            //             await next(context);
            //         }
            //     }
            //     catch (Exception ex)
            //     {
            //         Metrics.Increment("Exception", 1, new Dictionary<string, string> { { "Type", ex.GetType().Name } });
            //         throw;
            //     }
            // });

            app.UseMvc();
        }
    }
}
