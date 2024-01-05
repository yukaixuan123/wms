using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Wh;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 进货退货明细表
    /// </summary>
    internal class Wh_return_supply_dConfiger : IEntityTypeConfiguration<Wh_return_supply_d>
    {
        public void Configure(EntityTypeBuilder<Wh_return_supply_d> builder)
        {
            builder.ToTable(nameof(Wh_return_supply_d));
            builder.HasKey(e => e.item_codeId);
            builder.Property(e => e.item_code).HasColumnType("char(6)").IsRequired();
            builder.Property(e => e.return_goods_num).IsRequired().HasMaxLength(18).HasColumnType("decimal(18,2)");
            builder.Property(e => e.buy_price).IsRequired().HasMaxLength(18).HasColumnType("decimal(18,2)");
            builder.Property(e => e.return_money).IsRequired().HasMaxLength(18).HasColumnType("decimal(18,2)");
            builder.Property(e => e.batch_no).HasMaxLength(30).IsUnicode(false);
            builder.Property(e => e.model_code).HasMaxLength(64).IsUnicode(false);
        }
    }
}
