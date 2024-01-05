using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Ku
{
    /// <summary>
    /// 出库管理明细表
    /// </summary>
    public class Wh_outbill_d
    {
        public int outbill_d_id { get; set; }
        public string outbill_code { get; set; }
        public string item_code { get; set; }
        public string item_type { get; set; }
        public string unit { get; set; }
        public Decimal sale_num { get; set; }
        public Decimal outbill_num { get; set; }
        public string area_code { get; set; }
        public Decimal sale_price { get; set; }
        public string batch_no { get; set; }
        public DateTime product_date { get; set; }
        public string barcode { get; set; }
        public string create_by { get; set; }
        public DateTime create_time { get; set; }
        public DateTime update_time { get; set; }
        public string update_by { get; set; }
        public string remark { get; set; }
        public Decimal zong { get; set; }
        public string is_del { get; set; }

    }
}
