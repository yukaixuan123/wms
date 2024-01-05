using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Pc
{
    /// <summary>
    /// 批次库存表
    /// </summary>
    public class Wh_batch_storage
    {
        public int batch_storage_id { get; set; }
        public string ware_code { get; set; }
        public string area_code { get; set; }
        public string inbill_type { get; set; }
        public string item_code { get; set; }
        public string unit { get; set; }
        public Decimal inbill_num { get; set; }
        public Decimal outbill_num { get; set; }
        public Decimal plan_outbill_num { get; set; }
        public Decimal buy_price { get; set; }
        public DateTime product_date { get; set; }
        public string batch_no { get; set; }
      
    }
}
