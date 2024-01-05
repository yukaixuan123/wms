using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Shi
{
    public class Bb_view
    {
        public int item_id { get; set; }
        public string item_code { get; set; }
        public string item_name { get; set; }
        public Decimal inbill_price { get; set; }
        public string unit { get; set; }
        public string model_code { get; set; }
        public string item_type_name { get; set; }
    }
}
