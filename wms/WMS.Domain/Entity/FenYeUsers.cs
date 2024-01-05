using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity
{
    public class FenYeUsers<T>
    {
        public IEnumerable<T> List { get; set; }
        public int TotalPages { get; set; }//总页数

        public int PageSize { get; set; }
        public int CurrentPage { get; set; }
        public int Rows { get; set; }
    }
}
