using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Threading;
using Microsoft.AspNetCore.Mvc;
using InfluxDB.Collector;

namespace aspnetcoreapp.Controllers
{
    [Route("api/[controller]")]
    public class ValuesController : Controller
    {
        private IEnumerable<string> Query(int id)
        {
            var random = new Random();
            var numberOfRecords = random.Next(0, id);
            var records = Enumerable.Range(0, numberOfRecords).Select(x => Guid.NewGuid().ToString().Substring(0, 8));
            var ms = random.Next(0, 2000);
            Thread.Sleep(ms);
            return records;
        }

        // GET api/values/5
        [HttpGet("{id}")]
        public IEnumerable<string> Get(int id)
        {
            var tags = new Dictionary<string, string>();
            tags.Add("CorrelationId", Guid.NewGuid().ToString());

            using (var time = Metrics.Time("Query", tags))
            {
                var records = Query(id);
                Metrics.Measure("Records", records.Count(), tags);  
                return records;  
            }
        }
    }
}
