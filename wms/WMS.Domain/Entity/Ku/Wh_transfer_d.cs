using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Ku
{
    /// <summary>
    /// 调拨明细表
    /// </summary>
    public class Wh_transfer_d
    {
        public int transfer_d_id { get; set; }
        public string transfer_code { get; set; }
        public string wh__transfer_code { get; set; }
        public string item_code { get; set; }
        public string model_code { get; set; }
        public string unit { get; set; }
        public string outarea_code { get; set; }
        public string inarea_code { get; set; }
        public int out_num { get; set; }
        public int in_num { get; set; }
        public Decimal inbill_price { get; set; }
    }
}
