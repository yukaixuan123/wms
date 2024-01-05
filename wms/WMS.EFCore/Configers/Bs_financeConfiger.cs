using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity.Sup;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 财务表
    /// </summary>
    internal class Bs_financeConfiger : IEntityTypeConfiguration<Bs_finance>
    {
        public void Configure(EntityTypeBuilder<Bs_finance> builder)
        {
            builder.ToTable(nameof(Bs_finance));
            builder.HasKey(e => e.finance_id);
            builder.Property(e => e.finance_name).HasMaxLength(80).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.tax_no).HasMaxLength(80).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.bank_no).HasMaxLength(80).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.open_bank).HasMaxLength(80).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.open_adr).HasMaxLength(225).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.finance_type).HasMaxLength(10).IsUnicode(false).IsRequired(false);
        }
    }
}
