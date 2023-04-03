import SwiftUI

struct ReportView: View {
    @Binding var selectedDrawerView: DrawerView
    @ObservedObject var drawerData = DrawerData()

    var body: some View {
        ScrollView {
            VStack {
                drawerTotalsSection
                safeTotalsSection
                depositTotalsSection
                exportSection
            }
            .padding(.horizontal)
            .padding(.vertical, 60)
        }
    }
   
    var drawerTotalsSection: some View {
        ZStack(alignment: .leading) {
            VStack {
                HStack {
                    Text("Drawer 1 Total: ")
                    Text("\(drawerData.totalDepositForDrawer(0), specifier: "%.2f")")
                    Spacer()
                }
                HStack {
                    Text("Drawer 2 Total: ")
                    Text("\(drawerData.totalDepositForDrawer(1), specifier: "%.2f")")
                    Spacer()
                }
                HStack {
                    Text("Drawer 3 Total: ")
                    Text("\(drawerData.totalDepositForDrawer(2), specifier: "%.2f")")
                    Spacer()
                }
                Divider()
                HStack {
                    Text("Total Drawers: ")
                    Text("\(drawerData.totalDepositAmount, specifier: "%.2f")")
                    Spacer()
                }
            }
        }
    }
    
    var safeTotalsSection: some View {
        ZStack(alignment: .leading) {
            VStack {
                Divider()
                HStack {
                    Text("Safe Total: ")
                    Text("\(drawerData.totalDepositForSafe, specifier: "%.2f")")
                    Spacer()
                }
            }
        }
    }
    
    var depositTotalsSection: some View {
        ZStack(alignment: .leading) {
            VStack {
                Divider()

                HStack {
                    Text("Drawer 1 Deposit: ")
                    Text("\(drawerData.depositAmountForDrawer(0), specifier: "%.2f")")
                    Spacer()
                }
                HStack {
                    Text("Drawer 2 Deposit: ")
                    Text("\(drawerData.depositAmountForDrawer(1), specifier: "%.2f")")
                    Spacer()
                }
                HStack {
                    Text("Drawer 3 Deposit: ")
                    Text("\(drawerData.depositAmountForDrawer(2), specifier: "%.2f")")
                    Spacer()
                }
                Divider()
                HStack {
                    Text("Total Deposit: ")
                    Text("\(drawerData.totalDepositAmount, specifier: "%.2f")")
                    Spacer()
                }
                Divider()
            }
        }
    }
    
    var exportSection: some View {
        ZStack(alignment: .leading) {
            VStack {
                Text("*Export section")
            }
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(selectedDrawerView: .constant(.report))
    }
}

class DrawerData: ObservableObject {
    @Published var enteredTexts: [[String]] = Array(repeating: Array(repeating: "0", count: 12), count: 5)
    
    var totalDepositForSafe: Double {
        var total = 0.0
        for i in 0..<3 {
            total += calculateDeposit(texts: enteredTexts[i])
        }
        return total
    }
    
    var totalDepositAmount: Double {
        return depositAmountForDrawer(0) + depositAmountForDrawer(1) + depositAmountForDrawer(2)
    }
    
    func depositAmountForDrawer(_ drawerIndex: Int) -> Double {
        return calculateDeposit(texts: enteredTexts[drawerIndex])
    }
    
    func totalDepositForDrawer(_ drawerIndex: Int) -> Double {
        return calculateDeposit(texts: enteredTexts[drawerIndex])
    }
    
    func calculateDeposit(texts: [String]) -> Double {
        let billValues = [100, 50, 20, 10, 5, 2, 1]
        let coinValues = [0.25, 0.1, 0.05, 0.01, 1.0]
        
        let totalValue = Array(0..<7).reduce(0.0) { result, i in
            let value = Double(texts[i]) ?? 0.0
            return result + value * Double(billValues[i])
        } + Array(7..<12).reduce(0.0) { result, i in
            let value = Double(texts[i]) ?? 0.0
            return result + value * coinValues[i - 7]
        }
        let depositAmount = totalValue - 200.0
        return depositAmount
    }
}
